# Web server cluster module example

This folder contains example [Terraform](https://www.terraform.io/) configuration that define a module for deploying a 
cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto 
Scaling](https://aws.amazon.com/autoscaling/)) and a load balancer (using 
[ELB](https://aws.amazon.com/elasticloadbalancing/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 
The load balancer listens on port 80 and returns the text "Hello, World" for the `/` URL.