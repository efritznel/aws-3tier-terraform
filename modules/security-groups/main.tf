resource "aws_security_group" "external_alb" {
  name        = "${var.env}-external-alb-sg"
  description = "Allow HTTP from internet to external ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-external-alb-sg" })
}

resource "aws_security_group" "web" {
  name        = "${var.env}-web-sg"
  description = "Allow HTTP from external ALB to web servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from external ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.external_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-web-sg" })
}

resource "aws_security_group" "internal_alb" {
  name        = "${var.env}-internal-alb-sg"
  description = "Allow HTTP from web servers to internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from web servers"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-internal-alb-sg" })
}

resource "aws_security_group" "app" {
  name        = "${var.env}-app-sg"
  description = "Allow port 8080 from internal ALB to app servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "App port from internal ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-app-sg" })
}

resource "aws_security_group" "db" {
  name        = "${var.env}-db-sg"
  description = "Allow MySQL from app servers to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from app servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-db-sg" })
}
