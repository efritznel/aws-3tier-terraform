variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ"
  type        = list(string)
}

variable "private_web_subnet_cidrs" {
  description = "CIDR blocks for private web-tier subnets, one per AZ"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private app-tier subnets, one per AZ"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets, one per AZ"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across (must match subnet CIDR list lengths)"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
