terraform {
  backend "s3" {
    bucket = "practicetfstate"
    key    = "tfnewstate/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_instance" "sample" {
  ami           = "ami-0108d6a82a783b352"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_sample.id}"]
  user_data = <<EOF
               #! /bin/bash
                   sudo su
                   yum update -y
                   yum install httpd -y
                   cd /var/www/html
                   echo "hello from webserver vpc" > index.html
                   service start httpd
                   chkconfig httpd on
  EOF
  tags = {
    Name = "webserver"

  }

  }


resource "aws_security_group" "allow_sample" {
  name        = "allow_sample"
  description = "Allow sample ibnound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webserver sg"
  }
  }