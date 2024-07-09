# output to return the database address and port
output "address" {
    description = "Connect to the database at this endpoint"
    value = aws_db_instance.example.address
}

output "port" {
    description = "the port the database is listening on"
    value = aws_db_instance.example.port
}