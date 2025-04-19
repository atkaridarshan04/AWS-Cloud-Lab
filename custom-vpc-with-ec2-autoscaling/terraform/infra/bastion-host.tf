resource "aws_instance" "bastion-host" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key-pair.key_name

  associate_public_ip_address = true

  subnet_id              = module.vpc.public_subnets[0] # Public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone      = module.vpc.azs[0]

  tags = {
    Name        = "${var.name}-bastion-host"
    Environment = var.env
  }
}
