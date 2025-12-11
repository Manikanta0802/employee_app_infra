#testing-1

###############################
# VPC Module
###############################
module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
}

###############################
# Security Groups
###############################
module "security_groups" {
  source     = "./modules/security_groups"
  vpc_id     = module.vpc.vpc_id
  my_ip_cidr = var.my_ip_cidr
}

###############################
# RDS (using PUBLIC subnet IDs)
###############################
module "rds" {
  source             = "./modules/rds"
  public_subnet_ids  = module.vpc.public_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_master_username = var.db_master_username
  db_master_password = var.db_master_password
}

###############################
# EC2 App Server
###############################
module "ec2" {
  source           = "./modules/ec2"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  ec2_sg_id        = module.security_groups.ec2_sg_id
  app_ami_id           = var.app_ami_id
  key_pair_name    = var.key_pair_name

  backend_image = ghcr.io/manikanta0802/employee-backend:5
  frontend_image = ghcr.io/manikanta0802/employee-frontend:5

  db_host     = module.rds.db_endpoint
  db_port     = 3306
  db_name     = "employee_availability"
  db_user     = var.db_master_username
  db_password = var.db_master_password
}

###############################
# EC2 Monitor Server
###############################
module "monitor_ec2" {
  source            = "./modules/monitor_ec2"
  public_subnet_id  = module.vpc.public_subnet_ids[1]
  monitor_sg_id     = module.security_groups.monitor_sg_id
  monitor_ami_id            = var.monitor_ami_id
  key_pair_name     = var.key_pair_name
}

###############################
# ALB
###############################
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  ec2_instance_id   = module.ec2.ec2_instance_id
}
