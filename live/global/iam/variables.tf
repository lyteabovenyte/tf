variable "user_names" {
    description = "the usernames used for the IAM resource"
    type = list(string)
    default = [ "amir", "mahkam", "ala" ]
}