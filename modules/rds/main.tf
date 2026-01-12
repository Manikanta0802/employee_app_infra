resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "mydb-subnet-group"
  }
}

resource "aws_db_instance" "my_db" {
  identifier             = "employees-db"
  engine                 = "mysql"
  engine_version         = "8.0.43"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"

  db_name                = "employee_attendance_db"
  username               = var.db_master_username
  password               = var.db_master_password

  skip_final_snapshot    = true
  multi_az               = false

  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]

  backup_retention_period = 0

  tags = {
    Name = "employees-db"
  }
}
