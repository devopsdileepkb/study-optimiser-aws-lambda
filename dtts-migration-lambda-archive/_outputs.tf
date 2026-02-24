output "lambda_role_arn" {
  value = module.iam_role.role_arn
}

output "lambda_function_name" {
  value = module.lambda_function.lambda_name
}

output "lambda_function_arn" {
  value = module.lambda_function.lambda_arn
}

output "event_rule_arn" {
  value = module.lambda_trigger.event_rule_arn
}