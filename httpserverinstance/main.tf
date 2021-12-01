terraform {
  backend "s3" {
    bucket = "practicetfstate"
    key    = "tfnewstate/terraform.tfstate"
    region = "us-east-1"
  }
  backend "s3" {
    bucket = "keypair"
    key    = "terraform-key-pair.pem"
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



  tags = {
    Name = "webserver sg"
  }
  }
variable "generated_key_name" {
  type        = string
  default     = "terraform-key-pair"
  description = "Key-pair generated by Terraform"
}

resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }

}


output "ssh_key" {
  description = "ssh key generated by terraform"
  value       = tls_private_key.dev_key.private_key_pem
  sensitive = true
}
