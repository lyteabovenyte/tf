output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "the domain name of the load balancer"
}

output "asg_name" {
    value = aws_autoscaling_group.example.name
    description = "the name of the Auto Scaling Group"
}

# exporting the security group id for the load balancer.
output "alb_security_group_id" {
    value = aws_security_group.alb.id
    description = "the ID of the security group attached to the load balancer"
}