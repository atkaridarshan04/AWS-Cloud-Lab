# ALB Security Group
resource "aws_security_group" "lb_sg" {
  name        = "${var.name}-lb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #     description = "Allow HTTPS"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-lb-sg"
    Environment = var.env
  }
}

# Target Group
resource "aws_lb_target_group" "lb_tg" {
  name     = "${var.name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/" 
    interval            = 30       
    timeout             = 5       
    healthy_threshold   = 2        
    unhealthy_threshold = 2        
    protocol            = "HTTP"   
  }

  tags = {
    Environment = var.env
  }
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = false # public facing ALB
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = module.vpc.public_subnets

  # enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "alb-logs"
  #     enabled = true
  #   }

  tags = {
    Name        = "${var.name}-alb"
    Environment = var.env
  }
}

# ALB Listner
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

  tags = {
    Environment = var.env
  }
}
