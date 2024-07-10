# ------------------
# REQUIRED PARAMETERS
# we must specify a value for each of these parameters
# ------------------

variable "db_username" {
    description = "the username of the database"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "the password of the database"
    type = string
    sensitive = true
}

# -------------------
# OPTIONAL PARAMETRS
# these parameters have reasonable defaults
# -------------------

variable "db_name" {
    description = "the name to use for the database"
    type = string
    default = "example_database_prod"
}