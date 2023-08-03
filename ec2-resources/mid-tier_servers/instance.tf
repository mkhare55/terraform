resource "aws_instance" "mis-tier" {
  ami           = var.image_id
  instance_type = var.instance_type
  count = 3
  #key_name      = "ssh_key"
  #key_name               = aws_key_pair.ssh_key.key_name
  #vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id


  tags = {
    Name = "mid-tier-server"
  }
}

