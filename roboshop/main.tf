terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


data "aws_ami" "aws_ami" {
  most_recent = true
  name_regex = "^cent*"
  owners = ["973714476881"]
}

variable "components" {
  default = ["mongodb","catalogue","user","cart","redis","shipping","mysql","rabbitmq","payment","frontend"]
}

resource "aws_spot_instance_request" "spotinstance" {
  count = length(var.components)
  ami           = data.aws_ami.aws_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-05bf9a59ca4476ee1"]

tags = {
  Name = element(var.components,count.index)
}
}

resource "aws_ec2_tag" "ec2tag" {
  count = length(var.components)
  key = "Name"
  resource_id = element(aws_spot_instance_request.spotinstance.*.spot_instance_id,count.index)
  value = element(var.components,count.index)
}

resource "null_resource" "remote_exec" {
  depends_on = [aws_route53_record.records]
  count      = length(var.components)
  connection {
    host = element(aws_spot_instance_request.spotinstance.*.private_ip, count.index)
    user = "centos"
    password = "DevOps321"

    inline = [
      "yum install python3-pip -y",
      "pip3 install pip --upgrade",
      "pip3 install ansible",
      "ansible-pull -u https://github.com/muralichimmili/ansible roboshop-pull.yml -e COMPONENT=${element(var.components,count.index)} -e ENV=dev"
    ]


  }

}

resource "aws_route53_record" "records" {
  count           = length(var.components)
  zone_id         = "Z0576540AOW7M5U5BGNC"
  name            = "${element(var.components, count.index)}-dev.myhostedzone"
  type            = "A"
  ttl             = "300"
  records         = [element(aws_spot_instance_request.spotinstance.*.private_ip, count.index)]
  allow_overwrite = true
}


