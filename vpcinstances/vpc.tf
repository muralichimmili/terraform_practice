resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

 tags = {
   Name = "My-VPC"
 }
}

resource "aws_subnet" "public-subnet" {
  cidr_block = "${var.public_subnet_cidr}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "ap-south-1a"

  tags = {

    Name = "web public subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  cidr_block = "${var.private_subnet_cidr}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "ap-south-1b"

  tags = {

      Name = "DB private subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {

      Name = "VPC internet gateway"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
  tags = {

    Name = "public subnet route table"
  }
}

resource "aws_route_table_association" "routetableassociation" {
  route_table_id = "${aws_route_table.routetable.id}"
  subnet_id = "${aws_subnet.public-subnet.id}"
}

resource "aws_security_group" "sgroupweb" {
  name = "vpc_test_web"
  description = "Allow incoming http connections & ssh access"
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol = "http"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    protocol = "icmp"
    to_port = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "web server sg"
  }
}

resource "aws_security_group" "sgroupdb" {
  name = "vpc_test_db"
  description = "Allow traffic from public subnet"
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    protocol = "icmp"
    to_port = -1
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "db sg"
  }
}