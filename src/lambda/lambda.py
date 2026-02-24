"""
Lambda function to zip file in s3
Based on organization template structure
"""

import os
import boto3
import tempfile
import zipfile

"""
Retrieve environment variables.
"""
environment = os.environ['ENVIRONMENT']
aws_region = os.environ['REGION']
bucket_name = os.environ['BUCKET']
target_role_arn = os.environ['TARGET_ROLE_ARN']
#============================================================

folder_prefix = "iqvia_export_unload/"
zip_file_name = "StudyO_INPUT_Files.zip"

def get_cross_account_s3_client():
    """
    Assume role in target account and return client 
    """
    sts_client = boto3.client("sts")

    assumed_role = sts_client.assume_role(
        RoleARN=target_role_arn,
        RoleSessionName="CrossAccountS3Session"
    )

    credentials = assumed_role['credentials']

    s3_client = boto3.client(
        "s3",
        region_name=aws_region,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )

    return s3_client


def handler(event, context ):

    s3_client = get_cross_account_s3_client()

    files, keys = loadfiles(s3_client, bucket_name, folder_prefix)
    if not files:
        return {"statusCode": 200, "body": "No CSV files found."}

    zip_path = create_zip(files)
    upload_zip(s3_client, zip_path, bucket_name, folder_prefix + zip_file_name)

    if event.get("source") == "aws.events":
        delete_originals(s3_client, bucket_name, keys)
        return {
            "statusCode":200,
            "body": f"Created {zip_file_name} and deleted source CSVs (daily run)"
        }
   
    return {
            "statusCode":200,
            "body": f"Created {zip_file_name} (S3 trigger, CSVs kept)"
    }



def loadfiles(s3_client, bucket, prefix):
   
    response = s3_client.list_objects_v2(Bucket=bucket, Prefix=prefix)

    local_files =[]
    keys = []

    if 'Contents' in response:
        for obj in response['Contents']:
            key = obj['key']
            #only include CSV files directly under folder (skip subfolder and zips)
            if not key.endswith(".csv"):
                continue

            if "/" in key[len(prefix):]:
                continue
            
            tmp_file_path = os.path.join(
                tempfile.gettemdir(), 
                os.path.basename(key)
                )
            
            print(f"Downloading {key} to {tmp_file_path}")
            s3_client.download_file(bucket, key, tmp_file_path)

            local_files.append(tmp_file_path)
            keys.append(key)


    return local_files,keys

def create_zip(files):

    #create a zip archive from given local CSV files
    
    tmp_zip_path = os.path.join(
        tempfile.gettempdir(),
        zip_file_name
    )
    
    with zipfile.ZipFile(tmp_zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for f in files:
            zipf.write(f, arcname=os.path.basename(f))

    print("Zip created at {tmp_zip_path}")
    return tmp_zip_path

def upload_zip(s3_client, zip_path, bucket, key):
    
    print(f"Uploading  {zip_path} to {bucket}/{key}")
    s3_client.upload_file(zip_path, bucket, key)

def delete_originals(s3_client,bucket, keys):

    for key in keys:
        print(f"Deleting {bucket}/{key}")
        s3_client.delete_object(Bucket=bucket, Key=key)
        

