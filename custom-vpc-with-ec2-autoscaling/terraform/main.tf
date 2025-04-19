module "infra-module" {
  source = "./infra"
  name = "demo"
  ami_id = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  env = "dev"
}