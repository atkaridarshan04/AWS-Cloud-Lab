variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-static-website-project-1-0001"
}

variable "cloudfront_comment" {
  default = "Static website hosted via S3 + CloudFront"
}