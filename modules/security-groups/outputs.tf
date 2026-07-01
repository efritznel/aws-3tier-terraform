output "external_alb_sg_id" {
  description = "Security group ID for the external ALB"
  value       = aws_security_group.external_alb.id
}

output "web_sg_id" {
  description = "Security group ID for web servers"
  value       = aws_security_group.web.id
}

output "internal_alb_sg_id" {
  description = "Security group ID for the internal ALB"
  value       = aws_security_group.internal_alb.id
}

output "app_sg_id" {
  description = "Security group ID for app servers"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security group ID for the RDS instance"
  value       = aws_security_group.db.id
}
