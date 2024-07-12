# the following resource create the same three IAM users using for_each on a resource.
resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name = each.value
}