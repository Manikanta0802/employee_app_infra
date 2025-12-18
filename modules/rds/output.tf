output "rds_endpoint" {
  description = "Full endpoint for the MySQL database"
  value       = aws_db_instance.my_db.endpoint
}

output "rds_address" {
  description = "Full address for the MySQL database"
  value       = aws_db_instance.my_db.address
}

output "rds_instance_id" {
  description = "Identifier of the RDS instance"
  value       = aws_db_instance.my_db.identifier
}

output "rds_instance_address" {
  description = "Hostname of the RDS instance"
  value       = split(":", aws_db_instance.my_db.endpoint)[0]
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.my_db.db_name
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.my_db.port
}

output "rds_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.my_db.arn
}
