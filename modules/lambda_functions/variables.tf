variable "function_name" {
    type = string
  
}

variable "lambda_role_arn" {
    type = string
  
}

variable "package_type" {
    type = string
    description = "zip or image"
    validation {
        condition = contains(["Zip" , "Image"], var.package_type)
        error_message = "package_type must be Zip or Image."
    }
  
}

# ZIP specific
variable "filename" {
    type = string
    default = null  
}

variable "handler" {
    type = string
    default = null  
  
}

variable "runtime" {
    type = string
    default = null  
  
}

# IMAGE specific
variable "image_url" {
    type = string
    default = null
}

variable "memory_size" {
    type = number
    default = 256
}

variable "timeout" {
    type = number
    default = 30
}

variable "environment_variables" {
    type = map(string)
    default = {}
}

# vpc configuration


variable "subnet_ids" {
    type = list(string)
    default = []
}

variable "security_group_ids" {
    type = list(string)
    default = []
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "lambda_architecture" {
    type = string
    default = x86_64
}

variable "reserved_concurrent_executions" {
  type        = number
  nullable    = false
  default     = 10
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#reserved_concurrent_executions"
}

variable "layers_arns" {
  type        = list(string)
  description = <<DOC
    The list of Lambda layer ARNs to use for the Lambda function.
    https://registry.terraform.io/providers/hashicorp/aws/5.94.1/docs/resources/lambda_function#layers
  DOC
  default     = []
  nullable    = false
}

variable "kms_key_arn" {
  type        = string
  description = "optional kms key arn for lambda environment"
  default     = null
}

variable "cloudwatch_log_group_name" {
  description = <<DOC
    The ARN of the CloudWatch log group to use for the Lambda function.
    This should be provided if you want to use an existing CloudWatch log group.
  DOC
  type        = string
  default     = ""
  nullable    = false
}

variable "enable_vpc" {
  type        = bool
  description = "condition to enable or disable vpc integration"
  default     = false
}