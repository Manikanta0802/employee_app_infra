variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "ec2_sg_id" {
  description = "The security group for the EC2 instance"
  type        = string
}

variable "app_ami_id" {
  description = "AMI ID for the EC2 app server"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "docker_image" {
  description = "Docker image to run on EC2 (provided by CI/CD)"
  type        = string
  default     = ""
}

variable "GHCR_TOKEN" {
  type = string
}

variable "GHCR_USER" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}
