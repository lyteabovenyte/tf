# storing data sensitive data, to pass through the environment variables.
# >>> export TF_VAR_db_username = "xyz"
# >>> export TF_VAR_db_password = "xyz"
variable "db_username" {
    description = "the username for the database"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "the password for the database"
    type = string
    sensitive = true
}