provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "example" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_groups.instance.id]

    user_data = <<-EOF
                    #!bin/bash
                    echo "hello-world" > index.html
                    nohub busybox httpd -f -p ${var.server_port} &
                    EOF

    user_data_replace_on_change = true

    tags = {
        Name = "terraform-example"
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