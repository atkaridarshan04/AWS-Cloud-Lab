variable "region" {
  default = "us-east-1"
}

variable "frontend_bucket_name" {
  default     = "frontend-s3-bucket-xyz-123"
  description = "S3 bucket name for frontend"
}

variable "dynamodb_table_name" {
  default = "ShortenedURLs"
}
