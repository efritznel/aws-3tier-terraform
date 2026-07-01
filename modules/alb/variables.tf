variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Logical name used in resource names (e.g. external-alb, internal-alb). Max combined with env: 32 chars."
  type        = string
}

variable "internal" {
  description = "Set to true for an internal (private) load balancer"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs to place the ALB in (public for external, private for internal)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_port" {
  description = "Port the target instances are listening on"
  type        = number
}

variable "listener_port" {
  description = "Port the ALB listener accepts traffic on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP path for ALB health checks"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
