output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2_sg.id
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}

output "monitor_sg_id" {
  value = aws_security_group.monitor_sg.id
}

output "n8n_sg_id" {
  value = aws_security_group.n8n_sg.id
}