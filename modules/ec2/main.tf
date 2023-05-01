resource "aws_security_group" "allow_all" {
  name        = "allow_everything"
  description = "Allow all traffic."
  # vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 0    # 0 (semantically equivalent to all)
    to_port          = 0    # 0 (semantically equivalent to all)
    protocol         = "-1" # "-1" (semantically equivalent to all)
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0    # 0 (semantically equivalent to all)
    to_port          = 0    # 0 (semantically equivalent to all)
    protocol         = "-1" # "-1" (semantically equivalent to all)
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_spot_instance_request" "instances" {
  ami           = data.aws_ami.alpine.image_id
  spot_price    = var.spot_price
  instance_type = var.instance_type
  key_name      = var.ssh_keypair_name

  user_data = var.user_data

  root_block_device {
    volume_size = var.volume_size_gb # disk space (GB)
  }

  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.allow_all.id]
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_keypair_name
  public_key = var.ssh_public_key # tls_private_key.private_key.public_key_openssh
}
