resource "aws_key_pair" "key-pair" {
  key_name   = "${var.name}-ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1XMg19RrCNGAydZb53mLsjI6T+eEc37QKvf4XpvF+ atkar@DA-PC"

  tags = {
    Name        = "${var.name}-ssh-key"
    Environment = var.env
  }
}

# EC2 Security Group 
resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-ec2-sg"
    Environment = var.env
  }
}


# Launch Template
resource "aws_launch_template" "launch_template" {
  name = "${var.name}-launch-template"

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = aws_key_pair.key-pair.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "<h1>Deployed via Terraform ASG</h1>" | sudo tee /var/www/html/index.html
  EOF
  )

  #   instance_market_options {
  #     market_type = "spot"
  #   }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 10
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.name}-launch-template"
      Environment = var.env
    }
  }
}
