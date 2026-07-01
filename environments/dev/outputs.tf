output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_web_subnet_ids" {
  description = "Private web-tier subnet IDs"
  value       = module.vpc.private_web_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app-tier subnet IDs"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"
  value       = module.vpc.private_db_subnet_ids
}

output "external_alb_dns_name" {
  description = "Public DNS name of the external ALB — use this to reach the application"
  value       = module.external_alb.alb_dns_name
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal ALB (accessible from within the VPC)"
  value       = module.internal_alb.alb_dns_name
}

output "web_asg_name" {
  description = "Name of the web-tier Auto Scaling Group"
  value       = module.web_asg.asg_name
}

output "app_asg_name" {
  description = "Name of the app-tier Auto Scaling Group"
  value       = module.app_asg.asg_name
}

output "rds_endpoint" {
  description = "RDS connection endpoint (host:port)"
  value       = module.rds.rds_endpoint
}

output "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the DB password"
  value       = module.rds.secret_arn
}
