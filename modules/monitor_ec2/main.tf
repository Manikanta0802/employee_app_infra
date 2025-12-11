resource "aws_instance" "monitor" {
  ami           = var.monitor_ami_id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [var.monitor_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y

    # Install docker
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user

    # Run prometheus using docker
    docker run -d -p 9090:9090 prom/prometheus

    # Run grafana using docker
    docker run -d -p 3000:3000 grafana/grafana
  EOF

  tags = {
    Name = "MonitoringNode"
  }
}
