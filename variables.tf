variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IP CIDR"
  default     = "0.0.0.0/0"
}

variable "db_master_username" {
  type        = string
  description = "Master username for MySQL"
  default     = "admin"
}

variable "db_master_password" {
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  type        = string
  default     = "office-key"
}

variable "app_ami_id" {
  type        = string
  default     = "ami-00ca570c1b6d79f36"
}

variable "monitor_ami_id" {
  type        = string
  default     = "ami-00ca570c1b6d79f36"
}

