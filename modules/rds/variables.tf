variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the RDS DB subnet group (must span at least 2 AZs)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the RDS instance"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "5.7"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for failover"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy (set to false for production)"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection (set to true for production)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
