provider "aws" {
    region = "us-east-2"
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-0fb653ca2d3203ac1"
    security_groups = [aws_security_groups.instance.id]
    instance_type = "t2.micro"

    user_data = <<-EOF
                #!bin/bash
                echo "Hello World" > index.html
                nohub busybox httpd -f -p ${var.server_port} &
                EOF

    # Required when using a launch_configuration with an auto scaling group
    lifecycle {
      # change the reference to the old launch-configuration to new one and then replace the launch-configuration
      create_before_destroy = true
    }
}

# creating a virtual-private-cloud
data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.id]
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

resource "aws_lb" "example" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = 80
    protocol = "HTTP"

    #by default returns a simple 404 response (not found)
    default_action {
        type = "fixed-response"

    fixed_response {
        content_type = "plain/text"
        message_body = "404: page not found"
        status_code = 404
    }
    }
}

resource "aws_security_group" "lb" {
    name = "terrafrom-example-alb"

    # allow inbound http requests
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # allow all outbound request
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# creating a target-group for ASG
resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

# add a listener rule that sends requests that match any path to
# the target group that contains our ASG
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
      path_pattern {
        values = ["*"]
      }
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_security_groups" "instance" {
    name = "terraform-example-instance"

    ingeress {
        from_port = var.server_port
        to_port = var.server_port 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# use it with -var flag or export TF_VAR_server_port
variable server_port {
    description = "the port the server would server HTTP requests"
    type = number
}

# replaced with "alb_dns_name"
# output "public_id" {
#     description = "the public_ip that the server is served on"
#     value = aws_instance.example.public_ip
# }

output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "the domain name of the load balancer"
}