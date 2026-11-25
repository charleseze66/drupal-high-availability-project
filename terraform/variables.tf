
variable "aws_region" {
  description = "AWS region for the Drupal infrastructure"
  type        = string
  default     = "eu-north-1"
}

variable "admin_cidr" {
  description = "Your public IP address allowed to SSH into application servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Drupal application servers"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS MySQL instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Drupal database name"
  type        = string
  default     = "drupaldb"
}

variable "db_username" {
  description = "Drupal database username"
  type        = string
  default     = "drupaladmin"
}
variable "db_password" {
  description = "Password for the Drupal database"
  type        = string
  sensitive   = true
}