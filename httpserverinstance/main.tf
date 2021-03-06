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
  key_name        = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_sample.id}"]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${tls_private_key.dev_key.private_key_pem}"
    host     = "${aws_instance.sample.public_ip}"
  }
  provisioner "local-exec" {
    inline = [
   /*   "echo hello world",
      "pwd",
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "echo hi terraform is doing automation > index.html",
      "sudo cp /home/ec2-user/index.html /var/www/html/",
      "sudo service start httpd",
      "sudo chkconfig httpd on",*/
      "yum install "
    "ansible ${aws_instance.sample.public_ip} -m ansible.builtin.yum -a name=httpd state=present --key-file=${aws_key_pair.generated_key.key_name} -u=ec2-user -b"]
    ]
  }
  tags = {
    Name = "webserver"

  }

  }



resource "aws_security_group" "allow_sample" {
  name        = "allow_sample"
  description = "Allow sample ibnound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = null
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = null
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

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
  depends_on = [ tls_private_key.dev_key]
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  /*provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }*/

}


/*output "ssh_key" {
  description = "ssh key generated by terraform"
  value       = tls_private_key.dev_key.private_key_pem
  sensitive = true
}*/
