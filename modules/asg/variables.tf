variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Logical tier name used in resource names (e.g. web, app)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for instances in this ASG"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_ids" {
  description = "Security group IDs to attach to launched instances"
  type        = list(string)
}

variable "user_data_script" {
  description = "Raw shell script to run at instance launch (will be base64 encoded)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ASG will launch instances"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB target group ARNs to register instances with"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
