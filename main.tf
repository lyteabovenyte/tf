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
    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
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

output "public_id" {
    description = "the public_ip that the server is served on"
    value = aws_instance.example.public_ip
}