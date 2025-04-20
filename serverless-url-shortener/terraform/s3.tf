resource "aws_s3_bucket" "frontend" {
  bucket        = var.frontend_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "frontend_ownership" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowCloudFrontAccess",
      Effect    = "Allow",
      Principal = {
        Service = "cloudfront.amazonaws.com"
      },
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.frontend.arn}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.frontend_cdn.arn
        }
      }
    }]
  })
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }
}

# resource "aws_s3_object" "index" {
#   bucket       = aws_s3_bucket.frontend.id
#   key          = "index.html"
#   source       = "${path.module}/s3/index.html"
#   content_type = "text/html"
# }
