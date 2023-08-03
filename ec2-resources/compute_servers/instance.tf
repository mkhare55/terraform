
resource "aws_instance" "compute" {
  ami           = var.image_id
  instance_type = var.instance_type
  count = 1
  #key_name      = "ssh_key"
  #key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id

  tags = {
    Name = "compute-server"
  }
}



