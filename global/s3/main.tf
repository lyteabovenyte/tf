provider "aws" {
    region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-amir-ala"
    # the file path where the terraform state could be written (withing the s3 bucket)
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"

    # the dynamodb table used for locking
    dynamodb_table = "terrafrom-amir-ala"
    # encrypt terraform state
    encrypt = true
  }
}

# remote backend to store terraform states.
resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-amir-ala"

    # prevent this s3 bucket to be deleted
    lifecycle {
      prevent_destroy = true
    }
}

# enable versioning so you can see the whole revision history of your
# state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = "aws_s3_bucket.terrafrom_state.id"

  versioning_configuration {
    status = "Enabled"
  }
}

# enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = "aws_s3_bucket.terraform_state.id"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# explicitly block all public access to the s3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = "aws_s3_bucket.terraform_state.id"
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# creating a DynamoDB table for locking
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-amir-ala"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# ------ workspaced instance ---------
# terraform {
#   backend "s3" {
#     bucket = "terrafrom-amir-ala"
#     key = "workspace-example/terraform.tfstate"
#     region = "us-east-2"

#     dynamodb_table = "terraform-amir-ala"
#     encrypt = true
#   }
# }

# resource "aws_instance" "example" {
#   ami = "ami-0fb653ca2d3203ac1"
#   instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
# }
# ------ workspace instance ------------




