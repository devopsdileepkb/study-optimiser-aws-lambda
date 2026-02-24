output "event_rule_arn" {
  description = "ARN of the EventBridge rule"
  value = aws_cloudwatch_event_rule.daily_trigger.arn
}

output "event_target_id" {
    description = "ID of the EventBridge target"
    value = aws_cloudwatch_event_rule.lambda_target.id
  
}