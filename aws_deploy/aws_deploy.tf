provider "aws" {
  profile   = "default"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region    = "us-east-2"
}

resource "aws_key_pair" "wordpress-key" {
  key_name    = "wordpress-key"
  public_key  = "ssh-rsa PUBLICKEY"
}

resource "aws_security_group" "wordpress_group" {
  name        = "wordpress_group"
  description = "allows ssh and http(s) access to the wordpress boxes"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wordpress_db_group" {
  name        = "wordpress_db_group"
  description = "allows mysql access from app to db server"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.wordpress_app.private_ip}/32"]
  }
  depends_on = ["aws_instance.wordpress_app"]
}

resource "aws_instance" "wordpress_app" {
  ami                    = "ami-03ffa9b61e8d2cfda"
  key_name               = "wordpress-key"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.wordpress_group.id]
}

resource "aws_instance" "wordpress_db" {
  ami             = "ami-03ffa9b61e8d2cfda"
  key_name        = "wordpress-key"
  instance_type   = "t2.medium"
  vpc_security_group_ids = [
    aws_security_group.wordpress_group.id,
    aws_security_group.wordpress_db_group.id
  ]
}

output "wordpress_db_address" {
  value = aws_instance.wordpress_db.public_dns
}

output "wordpress_db_private_address" {
  value = aws_instance.wordpress_db.private_dns
}

output "wordpress_app_address" {
  value = aws_instance.wordpress_app.public_dns
}