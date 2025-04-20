output "api_url" {
  value = aws_apigatewayv2_api.url_shortener_api.api_endpoint
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.frontend_cdn.domain_name
}

# output "frontend_url" {
#   value = "http://${aws_s3_bucket.frontend.bucket}.s3-website-${var.region}.amazonaws.com"
# }