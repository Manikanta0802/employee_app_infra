#testing-1

# VPC Module
module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Security Groups
module "security_groups" {
  source     = "./modules/security_groups"
  vpc_id     = module.vpc.vpc_id
  my_ip_cidr = var.my_ip_cidr
}


# RDS (using PUBLIC subnet IDs)
module "rds" {
  source             = "./modules/rds"
  public_subnet_ids  = module.vpc.public_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
}


# EC2 App Server
module "ec2" {
  source           = "./modules/ec2"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  ec2_sg_id        = module.security_groups.ec2_sg_id
  app_ami_id           = var.app_ami_id
  key_pair_name    = var.key_pair_name

  backend_image = "ghcr.io/manikanta0802/employee-backend:11"
  frontend_image = "ghcr.io/manikanta0802/employee-frontend:11"
  GHCR_USER   = var.GHCR_USER
  GHCR_TOKEN  = var.GHCR_TOKEN
  db_host     = module.rds.rds_address
  db_port     = 3306
  db_name     = "employee_attendance_db"
  db_user     = var.db_master_username
  db_password = var.db_master_password
}


# EC2 Monitor Server
module "monitor_ec2" {
  source            = "./modules/monitor_ec2"
  public_subnet_id  = module.vpc.public_subnet_ids[1]
  monitor_sg_id     = module.security_groups.monitor_sg_id
  monitor_ami_id            = var.monitor_ami_id
  app_private_ip    = module.ec2.app_ec2_private_ip
  n8n_private_ip    = module.n8n_ec2.n8n_private_ip
  key_pair_name     = var.key_pair_name
  depends_on = [module.ec2, module.n8n_ec2]
}


# EC2 n8n Server
module "n8n_ec2" {
  source = "./modules/n8n_ec2"

  ami_id           = var.n8n_ami_id
  instance_type    = "t3.micro"
  subnet_id        = module.vpc.public_subnet_ids[1]
  security_group_id = module.security_groups.n8n_sg_id
  key_name         = var.key_pair_name
}


# ALB
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  ec2_instance_id   = module.ec2.ec2_instance_id
}
