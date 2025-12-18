output "n8n_private_ip" {
  value = aws_instance.n8n.private_ip
}

output "n8n_public_ip" {
  value = aws_instance.n8n.public_ip
}