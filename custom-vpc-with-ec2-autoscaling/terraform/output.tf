output "alb_dns_name" {
  value = module.infra-module.alb_dns_name
}

output "bastion_host_public_ip" {
  value = module.infra-module.bastion_host_public_ip
}

output "vpc_id" {
  value = module.infra-module.vpc_id
}

output "private_subnet_id" {
  value = module.infra-module.private_subnets
}