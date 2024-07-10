terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-amir-ala"
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-amir-ala"
    encrypt = true
    }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-amir-ala"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    db_name = var.db_name
    username = var.db_username
    password = var.db_password
}
