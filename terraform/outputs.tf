
output "vpc_id" {
  description = "Drupal VPC ID"
  value       = aws_vpc.drupal_vpc.id
}

output "availability_zones" {
  description = "Availability zones used"
  value       = slice(data.aws_availability_zones.available.names, 0, 2)
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = aws_subnet.private_db[*].id
}

output "autoscaling_group_name" {
  description = "Drupal application Auto Scaling Group"
  value       = aws_autoscaling_group.drupal_app.name
}

output "nat_gateway_public_ips" {
  description = "Public IP addresses of the NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "load_balancer_dns" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.drupal_alb.dns_name
}

output "drupal_website_url" {
  description = "Drupal website URL"
  value       = "http://${aws_lb.drupal_alb.dns_name}"
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.drupal_db.endpoint
}
