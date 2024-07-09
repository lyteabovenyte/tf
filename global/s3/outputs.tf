# checking the backend and the s3 bucket with these outputs
output "s3_bucket_arn" {
  value = "aws_s3_bucket.terraform_state.arn"
  description = "the s3 bucket arn name, tested"
}

output "dynamodb_table_name" {
  value = "aws_dynamodb_table.terraform_locks.name"
  description = "aws dynamodb table name, tested"
}