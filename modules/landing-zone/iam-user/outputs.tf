# output "user_arn" {
#     description = "the ARN of the users"
#     value = aws_iam_user.exmaple.arn
# }

output "all_users" {
    description = "all users values for each users key."
    value = aws_iam_user.example
}

output "all_arns" {
    description = "the arn of all the users"
    value = values(aws_iam_user.example)[*].arn
}