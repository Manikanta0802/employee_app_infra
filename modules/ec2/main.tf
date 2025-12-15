resource "aws_instance" "app_server" {
  ami                         = var.app_ami_id
  instance_type               = "t3.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.ec2_sg_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }

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


resource "aws_iam_role" "ec2_ssm_role" {
  name = "app-server-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "app-server-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

