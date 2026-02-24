variable "event_bridge_rule_name" {
    type = string
    
}

variable "schedule_expresion" {
  type = string
  default = "cron(0 1 * * ? *)" #1AM UTC/GMT daily
}

variable "lambda_function_arn" {
  type = string
  description = "ARN of the Lambda function"
}
variable "lambda_function_name" {
    type = string
    description = "Name of the Lambda functiona"

}
