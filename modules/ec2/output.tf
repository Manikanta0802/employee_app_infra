output "ec2_public_ip" {
  description = "The public IP of the EC2 app server"
  value       = aws_instance.app_server.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.app_server.id
}

output "app_ec2_private_ip" {
  value = aws_instance.app_server.private_ip
}