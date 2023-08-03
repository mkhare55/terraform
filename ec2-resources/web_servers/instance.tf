resource "aws_instance" "web" {
  ami           = var.image_id
  instance_type = var.instance_type
  count = 2
  #key_name      = "ssh_key"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  # root disk
  # root_block_device {
  #   volume_size           = "8"
  #   volume_type           = "gp2"
  #   encrypted             = true
  #   kms_key_id        = "${aws_kms_key.kopi-kms-key.arn}"
  #   delete_on_termination = true
  # }
  # # data disk
  # ebs_block_device {
  #   device_name           = "/dev/xvda"
  #   volume_size           = "8"
  #   volume_type           = "gp2"
  #   encrypted             = true
  #   kms_key_id        = "${aws_kms_key.kopi-kms-key.arn}"
  #   delete_on_termination = true
  # }

  tags = {
    Name = "web-server"
  }
  user_data = file("${path.module}/script.sh")
}

# resource "aws_kms_key" "kopi-kms-key" {
#   description              = "KopiCloud KMS Key"
#   deletion_window_in_days  = 10
#   customer_master_key_spec = "SYMMETRIC_DEFAULT"
# }

# output "kms_key" {
#   description = "KMS ARN"
#   value       = "echo 'meri kms key aa gayi' ${aws_kms_key.kopi-kms-key.arn}"
# }

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  #public_key = file("${path.module}/ssh_key.pub")
  #public_key = var.key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfUulOPgGtI/TC6qazgj+o2bqYD7/xqOdNEYlo3T2LK+IjaLXS5G+rLkrKamYFxG4E81/CN9EhLkwUu0pP3TGAss7BgzIFM0tw+WnK16qASlNL5xasSv+BCd7dbAHtKI0icIRBUomHuZibG8guxfOsxhgU3yuw2JlW/z1sKSP+7x2A+ZA1clYkpNELSsShPdIZDot+6Gi23vIv4aFw2qsyk/NssUREhc+5w9ry4Na5U5oFWdGzKNqWqZ2uBGZ2vrdKg4SvJGyezEOasY/ErkwZoslvjcxrI7XoIlkp8tSlTRpNensnU4QjfcKsK6Ac4aaOuYtQrMrDUf22L6+/ou/b impadmin@IMPETUS-L206U"
}

output "keyname" {
  value = aws_key_pair.ssh_key.key_name
}





