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
  region  = "us-east-1"
}
variable "instance_type" {
  type=string
}

variable "env" {
}
variable "list_servername" {
  type = list(string)
}
module "mawsinstance" {

  source   = "./awsInstance/"
  secgrpid = module.msecuritygroup.osecuritygrpid
  instype  = var.instance_type
   name    = var.list_servername
   #env     = var.env

}
module "msecuritygroup" {

  source = "./securitygroup"

}
output "public_ip" {
  value = " server1 :: ${module.mawsinstance.ip[0]}"
}