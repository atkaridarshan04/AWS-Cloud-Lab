terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

# Create an s3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-test-bucket-123-xyz"
}