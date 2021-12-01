
variable "aws_region"{
  description = " region for the vpc"
  default = "ap-south-1"
}
variable "vpc_cidr" {
  description = "cidr for the vpc"
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "cidr for the public subnet"
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  description = "cidr for the private subnet"
  default = "10.0.2.0/24"
}
variable "ami" {
  description = "Amazon Linux AMI"
  default = ""
}
variable "key_path" {
  description = "SSH public key path"
  default = "home/devops/.ssh/id_rsa.pub"
}
