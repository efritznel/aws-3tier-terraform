variable "env" {
  description = "Environment name, used as a prefix in all resource names"
  type        = string
}

variable "project" {
  description = "Project name, used for tagging"
  type        = string
}

variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

# ── VPC ──────────────────────────────────────────────────────────────────────

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
  description = "Availability zones to deploy subnets into"
  type        = list(string)
}

# ── Web ASG ───────────────────────────────────────────────────────────────────

variable "web_ami_id" {
  description = "AMI ID for web server instances"
  type        = string
}

variable "web_instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t2.micro"
}

variable "web_desired_capacity" {
  type    = number
  default = 2
}

variable "web_min_size" {
  type    = number
  default = 1
}

variable "web_max_size" {
  type    = number
  default = 4
}

# ── App ASG ───────────────────────────────────────────────────────────────────

variable "app_ami_id" {
  description = "AMI ID for app server instances"
  type        = string
}

variable "app_instance_type" {
  description = "EC2 instance type for app servers"
  type        = string
  default     = "t2.micro"
}

variable "app_desired_capacity" {
  type    = number
  default = 2
}

variable "app_min_size" {
  type    = number
  default = 1
}

variable "app_max_size" {
  type    = number
  default = 4
}

# ── RDS ───────────────────────────────────────────────────────────────────────

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_engine_version" {
  type    = string
  default = "5.7"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_multi_az" {
  description = "Enable Multi-AZ (recommended false for dev, true for prod)"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}
