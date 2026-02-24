resource "aws_lambda_function" "zip_csv_lambda" {
  /* Creates a Lambda function.
  https://registry.terraform.io/providers/hashicorp/aws/5.97.0/docs/resources/lambda_function */
  function_name                  = var.function_name
  package_type                   = var.package_type

  #zip specific

  filename                       = var.package_type == "Zip" ? var.filename : null
  source_code_hash = var.package_type == "Zip" && var.filename !=null ? filebase64sha256(var.filename) : null
  handler = var.package_type == "Zip" ? var.handler : null
  runtime = var.package_type == "Zip" ? var.runtime : null

  #image specific
  image_uri = var.package_type == "Image" ? var.image_url : null

  memory_size = var.memory_size
  timeout = var.timeout
  role                           = var.lambda_role_arn
  architectures = [var.lambda_architecture]
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers_arns
  kms_key_arn                    = var.kms_key_arn != null ? var.kms_key_arn : null
  dynamic "vpc_config" {
    for_each = var.enable_vpc ? [1] : []
    content {

    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
    }
  tracing_config { # Required for Compliance
    mode = "Active"
  }
  dynamic "logging_config" {
    for_each = length(var.cloudwatch_log_group_name) > 0 ? [1] : []
    content {
      log_format = "Text"
      log_group  = var.cloudwatch_log_group_name
    }
  }
  dynamic "logging_config" {
    for_each = length(var.cloudwatch_log_group_name) == 0 ? [1] : []
    content {
      log_format = "Text"
    }
  }
  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  }


