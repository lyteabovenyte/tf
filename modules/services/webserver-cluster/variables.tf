variable "cluster_name" {
    description = "the name to use for all the cluster resources"
    type = string
}

variable "db_remote_state_bucket" {
    description = "the name of teh s3 bucket for the database's remote state"
    type = string
}

variable "db_remote_state_key" {
    description = "the path for the database's remote state in s3"
    type = string
}

variable "instance_type" {
    description = "the type of the EC2 instance to run (e.g. t2.micro)"
    type = string
}

variable "min_size" {
    description = "the minimum number of EC2 instances in the ASG"
    type = number
}

variable "max_size" {
    description = "the maximum number of EC2 instances in the ASG"
    type = string
}

# optional parameters --> with reasonable default values
variable "server_port" {
    description = "the port the server will use for HTTP requests"
    type = number
    default = 8080
}

variable "custom_tags"  {
    description = "Custom tags to set on the instance in the ASG"
    type = map(string)
    default = {}
}