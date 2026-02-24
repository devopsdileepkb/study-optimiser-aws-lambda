resource "aws_iam_role_policy_attachment" "iam_policy_attach" {
  role       = var.iam_role_name
  policy_arn = var.role_policy_arn

}