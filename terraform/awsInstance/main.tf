resource "aws_instance" "sample" {
  count         = length(var.name)
 # ami           = "ami-0855cab4944392d0a"
   ami          = data.aws_ami.aws_ins.id
  instance_type = var.instype
  vpc_security_group_ids = [var.secgrpid]

  tags = {
    Name = element(var.name,count.index)
   # Name = "${local.envname}"
  }

}

resource "null_resource" "sample_resource" {

    triggers = {

        abc = aws_instance.sample.*.private_ip[0]
    }

  provisioner "remote-exec" {

    connection {
      host = aws_instance.sample.*.public_ip[0]
      user = "centos"
      password = "DevOps321"
    }
    inline = [
      "echo hello",
      "echo hai h r u?"
    ]

  }

}

locals {
    envname = " dev server instance"
}

data "aws_ami" "aws_ins" {

  most_recent      = true
  name_regex       = "Centos*"
  owners           = ["973714476881"]

}
variable "secgrpid" {
}
variable "instype" {
}

variable "name" {}

output "ip" {

  value = "${aws_instance.sample.*.public_ip}"
}