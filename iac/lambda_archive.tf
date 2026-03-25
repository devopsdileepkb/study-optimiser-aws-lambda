module "archive_lambda" {
    source = "../dtts-migration-lambda-archive"

    env                    = var.env
    policy_name            = var.policy_name
    aws_service_name       = var.aws_service_name
    project                = var.project
    package_type           = var.package_type
    policy_description     = var.policy_description
    event_bridge_rule_name = var.event_bridge_rule_name
    function_name          = var.function_name
    log_group_name         = var.log_group_name
    lambda_architecture    = var.lambda_architecture
    role_name              = var.role_name
    region                 = var.region
    project_name           = var.project_name
    crossaccount_role_arn  = var.crossaccount_role_arn

    environment_variables = {
        BUCKET          = var.archive_bucket
        ENVIRONMENR     = var.env
        REGION          = var.archive_bucket_region
        TARGET_ROLE_ARN = var.crossaccount_role_arn
    }
}
