resource "aws_lambda_function" "zip_csv_lambda" {
  count = lower(var.package_type) == "zip" ? 1 : 0

  function_name = var.function_name
  package_type  = "Zip"

  filename         = var.filename
  source_code_hash = var.filename != null ? filebase64sha256(var.filename) : null
  handler          = var.handler
  runtime          = var.runtime

  memory_size = var.memory_size
  timeout     = var.timeout
  role        = var.lambda_role_arn
  architectures = [var.lambda_architecture]
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers      = var.layers_arns
  kms_key_arn = var.kms_key_arn
}

resource "aws_lambda_function" "image_lambda" {
  count = lower(var.package_type) == "image" ? 1 : 0

  function_name = var.function_name
  package_type  = "Image"

  image_uri = var.image_url

  memory_size = var.memory_size
  timeout     = var.timeout
  role        = var.lambda_role_arn
  architectures = [var.lambda_architecture]
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers      = var.layers_arns
  kms_key_arn = var.kms_key_arn
}