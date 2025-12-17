variable "public_subnet_id" { type = string }
variable "monitor_sg_id" { type = string }
variable "monitor_ami_id" { type = string }
variable "key_pair_name" { type = string }
variable "app_private_ip" {
  description = "Private IP of application EC2"
  type        = string
}

variable "n8n_private_ip" {
  description = "Private IP of n8n EC2"
  type        = string
}