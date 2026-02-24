module "kms" {
    source = "../modules/kms"

}

module "cloudwatch_log_group" {
    source = "../modules/cloudwatch_log_group"
    log_group_name = var.log_group_name
    log_retention_in_days = var.log_retention_in_days
    kms_key_id = var.kms_key_id
    log_group_class = var.log_group_class
    tags = var.tags

  
}

module "iam_role" {
    source = "../modules/iam_role"
    role_name = var.role_name
    tags = var.tags
    aws_service_name = var.aws_service_name

}

module "iam_policy" {
    source = "../modules/iam_policy"
    policy_name = var.policy_name
    policy_description = var.policy_description
    policy_statements = [
  {
    Sid    = "Statement1"
    Effect = "Allow"
    Action = [
      "kms:ListKeys",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyPair"
    ]
    Resource = module.kms.kms_key_arn
  },
  {
    Sid    = "Statement2"
    Effect = "Allow"
    Action = [
      "logs:*"
    ]
    Resource = module.cloudwatch_log_group.log_group_arn
  }
]
    
    tags = var.tags
  
}

module "iam_policy_sts" {
  source             = "../modules/iam_policy"
  policy_name        = var.policy_name
  policy_description = var.policy_description

  policy_statements = [
    {
      Sid    = "Statement1"
      Effect = "Allow"
      Action = ["sts:AssumeRole"]
      Resource = var.crossaccount_role_arn
    }
  ]

  tags = var.tags
}


module "role_policy_attachment" {
    source = "../modules/iam_role_policy_attachment"
    iam_role_name = "${module.iam_role.role_name}"
    role_policy_arn = "${module.iam_policy.iam_policy_arn}"


}
module "role_policy_attachment_lambda_execution" {
    source = "../modules/iam_role_policy_attachment"
    iam_role_name = "${module.iam_role.role_name}"
    role_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}


module "lambda_function" {
    source = "../modules/lambda_functions"
    function_name = var.function_name
    lambda_architecture = var.lambda_architecture
    package_type = var.package_type
    lambda_role_arn = "${module.iam_role.role_arn}"
    kms_key_arn = module.kms.kms_key_arn
    cloudwatch_log_group_name = module.cloudwatch_log_group.log_group_name
    environment_variables = var.environment_variables
    filename = "${path.root}/lambda.zip"
    handler  = "lambda.handler"
    runtime  = "python3.11"
 
}

module "lambda_trigger" {
    source = "../modules/schedule_lambda_trigger"
    lambda_function_arn = module.lambda_function.lambda_arn
    event_bridge_rule_name = var.event_bridge_rule_name
    lambda_function_name = module.lambda_function.lambda_name
}

