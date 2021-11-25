resource "aws_instance" "sample" {
  count         = var.name == "dev-env"? 1 : 0
  ami           = "ami-0855cab4944392d0a"
  instance_type = var.instype
  vpc_security_group_ids = [var.secgrpid]

  tags = {
    Name = element(var.name,count.index)
  }

}
variable "secgrpid" {
}
variable "instype" {
}
variable "name" {
}
output "ip" {

  value = "${aws_instance.sample.*.public_ip}"
}