output "app_public_ip" {
  value       = module.ec2.ec2_public_ip
  description = "Public IP of app instance"
}

output "app_url" {
  value       = "http://${module.ec2.ec2_public_ip}:80"
  description = "App URL (Spring Boot default port)"
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "prometheus_url" {
  value = "http://${module.monitor_ec2.monitor_public_ip}:9090"
}

output "grafana_url" {
  value = "http://${module.monitor_ec2.monitor_public_ip}:3000"
}
output "n8n_url" {
  value = "http://${module.n8n_ec2.n8n_public_ip}:5678"
}

output "alb_dns_name" {
  value = "http://${module.alb.alb_dns_name}"
}