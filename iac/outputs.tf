output "lambda_role_arn" {
  value = module.archive_lambda.lambda_role_arn
}

output "lambda_function_name" {
  value = module.archive_lambda.lambda_function_name
}

output "lambda_function_arn" {
  value = module.archive_lambda.lambda_function_arn
}

output "event_rule_arn" {
  value = module.archive_lambda.event_rule_arn
}