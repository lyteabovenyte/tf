# optional parameter --> have a reasonable default value
variable "cluster_name" {
    description = "the name to use to namespace all the resources in the cluster"
    type = string
    default = "webserver-prod"
}

# required parameters --> you have to initialize
variable "db_remote_state_key" {
    description = "the name of the key in the s3 bucket used for the database's remote state storage"
    type = string
}

variable "db_remote_state_bucket" {
    description = "the name of the s3 bucket used for the database's remote state storage"
    type = string
}

# optional with a standard input
variable "user_names" {
    description = "create the IAM users with these names"
    type = list(string)
    default = ["amir", "mahkam", "ala"]
}