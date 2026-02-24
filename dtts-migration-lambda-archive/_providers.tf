terraform {
  required_providers {
    aws = {
      /* https://registry.terraform.io/providers/hashicorp/aws/latest/docs */
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    /* https://developer.hashicorp.com/terraform/language/settings/backends/configuration */
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    /* Default tags are overwritten by identical tags defined in resources.
    Tags for IAM roles can contain spaces, letters, numbers, and these characters:
    _ . : / = + - @
    */
    tags = {
      /* https://confluence.astrazeneca.com/x/7r9SGg */
      applicationname   = var.project_name                   # Title of project or name of application; lower case.
      applicationid     = ""                                   # Application identifier as per CMDB (ap####).
      applicationowner  = "firstname.lastname@astrazeneca.com" # Email of the application owner.
      businessportfolio = "biopharma"                          # Sub-business function level; one of "oncology / biopharma / shared / it".
      creationdate      = "dd-mm-yyyy"                         # Date of first creation.
      environment       = var.env                              # Deployment environment; one of: "dev / tst / sit / ppd / ppt / prd / dr".
      organization      = "science"                            # One of "commercial / science / enablingunits / ecs / ops / ets / ignite".
      rechargeref       = ""                                   # Unique value provided by FinOps.
      #repository        = "${{ values.destination }}"          # Repository hosting the IAC and code for this resource.
    }
  }

}
