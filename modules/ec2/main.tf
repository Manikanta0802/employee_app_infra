resource "aws_instance" "app_server" {
  ami                         = var.app_ami_id
  instance_type               = "t3.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.ec2_sg_id]
  associate_public_ip_address = true

    user_data = templatefile("${path.module}/userdata.sh", {
    backend_image = var.backend_image
    frontend_image = var.frontend_image
    db_host       = var.db_host
    db_port       = var.db_port
    db_name       = var.db_name
    db_user       = var.db_user
    db_password   = var.db_password
  })


  tags = {
    Name = "app-server"
    Project = "MiniProject"
  }
}
