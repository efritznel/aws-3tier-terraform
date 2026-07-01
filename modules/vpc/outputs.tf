output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_web_subnet_ids" {
  description = "IDs of the private web-tier subnets"
  value       = aws_subnet.private_web[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of the private app-tier subnets"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = aws_subnet.private_db[*].id
}
