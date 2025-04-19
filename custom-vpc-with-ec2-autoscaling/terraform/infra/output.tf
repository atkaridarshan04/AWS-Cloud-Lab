output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion-host.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
