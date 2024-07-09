# replaced with "alb_dns_name"
# output "public_id" {
#     description = "the public_ip that the server is served on"
#     value = aws_instance.example.public_ip
# }

output "alb_dns_name" {
    value = module.webserver_cluster.alb_dns_name
    description = "the domain name of the load balancer"
}