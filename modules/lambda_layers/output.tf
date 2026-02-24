output "layer_arn" {
  value = {
    for name , layer in aws_aws_lambda_layer_version.this :
    name => layer.arn
  }
}

output "layer_versions" {

  value = {
    for  name, layer in aws_aws_lambda_layer_version.this : 
    name => layer.version
  }
}
  
