resource "aws_instance" "sample" {
  count         = length(var.name)
  ami           = "ami-0855cab4944392d0a"
  instance_type = var.instype
  vpc_security_group_ids = [var.secgrpid]

  tags = {
    Name = element(var.name,count.index)
   # Name = "${local.envname}"
  }

}

locals {
    envname = " dev server instance"
}


variable "secgrpid" {
}
variable "instype" {
}

variable "name" {}

output "ip" {

  value = "${aws_instance.sample.*.public_ip}"
}