# AWS Provider
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Output these values for reference
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}