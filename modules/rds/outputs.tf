output "rds_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "rds_identifier" {
  description = "Identifier of the RDS instance"
  value       = aws_db_instance.this.identifier
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret storing the DB password"
  value       = aws_secretsmanager_secret.db_password.arn
}
