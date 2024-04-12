resource "aws_instance" "web" {
  ami                         = var.image_id     #"ami-09d56f8956ab235b3"
  instance_type               = var.inst_type[1] // or var.inst_type[0], var.inst_type[2]
  count                       = var.inst_count
  #associate_public_ip_address = true
  availability_zone           = var.az_name
  key_name                    = var.keyname
  vpc_security_group_ids      = [aws_security_group.allow_http_ssh.id]

  tags = var.ec2_instance_tags
}
