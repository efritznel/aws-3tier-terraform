resource "aws_launch_template" "this" {
  name_prefix   = "${var.env}-${var.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_group_ids
  }

  user_data = base64encode(var.user_data_script)

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.env}-${var.name}-instance" })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.env}-${var.name}-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-${var.name}-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
