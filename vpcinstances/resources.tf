resource "aws_key_pair" "default" {
  key_name = "vpckeypair"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "wb" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgroupweb.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("install.sh")}"

  tags = {
    Name = "Webserver"
  }
}

resource "aws_instance" "db" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgroupdb.id}"]
  source_dest_check = false

  tags = {
    Name = "database"
  }
}