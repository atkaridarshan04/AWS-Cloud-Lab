variable "name" {
  description = "Name of Project"
  type        = string
}

variable "env" {
  description = "Project Environment"
  type        = string
}

locals {
  cidr = "10.0.0.0/16"
  azs             = ["eu-north-1a", "eu-north-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for EC2 instance"
  type = string
}