provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket = "terraform-amir-ala"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "terraform-amir-ala"
        encrypt = true
    }
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-amir-ala"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    # as it's just for learning and we will soon destroy the resource
    skip_final_snapshot = true
    db_name = "example_database"

    username = var.db_username
    password = var.db_password
}