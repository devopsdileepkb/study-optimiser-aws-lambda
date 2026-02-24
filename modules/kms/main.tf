resource "aws_kms_key" "kms" {
    deletion_window_in_days = 7
    multi_region = var.key_to_be_multi_region
    tags = var.tags
}
  