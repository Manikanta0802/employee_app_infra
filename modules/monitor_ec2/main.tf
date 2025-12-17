resource "aws_instance" "monitor" {
  ami           = var.monitor_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [var.monitor_sg_id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/userdata.sh",{
  app_private_ip   = var.app_private_ip
  n8n_private_ip   = var.n8n_private_ip
  })

  tags = {
    Name = "MonitoringNode"
  }
}
