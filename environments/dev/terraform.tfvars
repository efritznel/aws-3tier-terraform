env     = "dev"
project = "3tier-homelab"
region  = "us-east-1"

# ── VPC ──────────────────────────────────────────────────────────────────────
vpc_cidr                 = "10.0.0.0/16"
availability_zones       = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24"]
private_web_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
private_app_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
private_db_subnet_cidrs  = ["10.0.6.0/24", "10.0.7.0/24"]

# ── Web ASG ───────────────────────────────────────────────────────────────────
web_ami_id           = "ami-068c0051b15cdb816" # Amazon Linux 2 (us-east-1)
web_instance_type    = "t2.micro"
web_desired_capacity = 2
web_min_size         = 1
web_max_size         = 4

# ── App ASG ───────────────────────────────────────────────────────────────────
app_ami_id           = "ami-068c0051b15cdb816" # Amazon Linux 2 (us-east-1)
app_instance_type    = "t2.micro"
app_desired_capacity = 2
app_min_size         = 1
app_max_size         = 4

# ── RDS ───────────────────────────────────────────────────────────────────────
db_name                = "mydb"
db_username            = "admin"
db_instance_class      = "db.t3.micro"
db_engine_version      = "5.7"
db_allocated_storage   = 20
db_multi_az            = false  # set to true for staging/prod
db_skip_final_snapshot = true   # set to false for staging/prod
db_deletion_protection = false  # set to true for staging/prod
