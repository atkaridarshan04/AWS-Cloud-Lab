resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                             = "frontend-oac"
  description                      = "CloudFront OAC for frontend"
  origin_access_control_origin_type = "s3"
  signing_behavior                 = "always"
  signing_protocol                 = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend_cdn" {
  origin {
    domain_name              = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id                = var.frontend_bucket_name
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.frontend_bucket_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  comment    = "Frontend CloudFront Distribution"
  web_acl_id = aws_wafv2_web_acl.frontend_waf.arn
}

resource "aws_wafv2_web_acl" "frontend_waf" {
  provider = aws.us_east_1

  name        = "frontend-waf"
  description = "WAF for frontend CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "frontendWAF"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRule"
      sampled_requests_enabled   = true
    }
  }
}
