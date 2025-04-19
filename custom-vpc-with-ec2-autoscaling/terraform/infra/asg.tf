# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name_prefix      = "${var.name}-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = module.vpc.private_subnets # Private subnets

  health_check_type         = "ELB" # Use ELB health checks
  health_check_grace_period = 300

  force_delete = true

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.lb_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.name}-ec2-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  wait_for_capacity_timeout = "0"
}
