resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/url-shortener"
  retention_in_days = 14
}
