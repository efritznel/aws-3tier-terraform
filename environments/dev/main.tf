locals {
  common_tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  env                      = var.env
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_web_subnet_cidrs = var.private_web_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  availability_zones       = var.availability_zones
  tags                     = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  env    = var.env
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags
}

module "external_alb" {
  source = "../../modules/alb"

  env                = var.env
  name               = "ext-alb"
  internal           = false
  security_group_ids = [module.security_groups.external_alb_sg_id]
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  target_port        = 80
  listener_port      = 80
  health_check_path  = "/"
  tags               = local.common_tags
}

module "web_asg" {
  source = "../../modules/asg"

  env                = var.env
  name               = "web"
  ami_id             = var.web_ami_id
  instance_type      = var.web_instance_type
  security_group_ids = [module.security_groups.web_sg_id]
  subnet_ids         = module.vpc.private_web_subnet_ids
  target_group_arns  = [module.external_alb.target_group_arn]
  desired_capacity   = var.web_desired_capacity
  min_size           = var.web_min_size
  max_size           = var.web_max_size
  user_data_script   = file("${path.module}/templates/web_user_data.sh")
  tags               = local.common_tags
}

module "internal_alb" {
  source = "../../modules/alb"

  env                = var.env
  name               = "int-alb"
  internal           = true
  security_group_ids = [module.security_groups.internal_alb_sg_id]
  subnet_ids         = module.vpc.private_app_subnet_ids
  vpc_id             = module.vpc.vpc_id
  target_port        = 8080
  listener_port      = 80
  health_check_path  = "/"
  tags               = local.common_tags
}

module "app_asg" {
  source = "../../modules/asg"

  env                = var.env
  name               = "app"
  ami_id             = var.app_ami_id
  instance_type      = var.app_instance_type
  security_group_ids = [module.security_groups.app_sg_id]
  subnet_ids         = module.vpc.private_app_subnet_ids
  target_group_arns  = [module.internal_alb.target_group_arn]
  desired_capacity   = var.app_desired_capacity
  min_size           = var.app_min_size
  max_size           = var.app_max_size
  user_data_script   = file("${path.module}/templates/app_user_data.sh")
  tags               = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  env                    = var.env
  subnet_ids             = module.vpc.private_db_subnet_ids
  security_group_ids     = [module.security_groups.db_sg_id]
  db_name                = var.db_name
  db_username            = var.db_username
  instance_class         = var.db_instance_class
  engine_version         = var.db_engine_version
  allocated_storage      = var.db_allocated_storage
  multi_az               = var.db_multi_az
  skip_final_snapshot    = var.db_skip_final_snapshot
  deletion_protection    = var.db_deletion_protection
  tags                   = local.common_tags
}
