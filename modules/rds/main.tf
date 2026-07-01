terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

resource "random_password" "db" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.env}/mysql/password"

  tags = merge(var.tags, { Name = "${var.env}-mysql-password" })
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.env}-db-subnet-group" })
}

resource "aws_db_instance" "this" {
  identifier        = "${var.env}-mysql"
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = aws_secretsmanager_secret_version.db_password.secret_string

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  multi_az            = var.multi_az
  publicly_accessible = false
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  tags = merge(var.tags, { Name = "${var.env}-rds" })
}
