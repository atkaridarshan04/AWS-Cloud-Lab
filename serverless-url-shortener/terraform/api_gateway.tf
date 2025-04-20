resource "aws_apigatewayv2_api" "url_shortener_api" {
  name          = "url-shortener-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]  # or cloudfront domain name if you want to restrict
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_integration" "create_integration" {
  api_id             = aws_apigatewayv2_api.url_shortener_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.create_short_url.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "redirect_integration" {
  api_id             = aws_apigatewayv2_api.url_shortener_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.redirect_url.invoke_arn
  integration_method = "POST"  
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "create_route" {
  api_id    = aws_apigatewayv2_api.url_shortener_api.id
  route_key = "POST /create"
  target    = "integrations/${aws_apigatewayv2_integration.create_integration.id}"
}

resource "aws_apigatewayv2_route" "redirect_route" {
  api_id    = aws_apigatewayv2_api.url_shortener_api.id
  route_key = "GET /{shortId}"
  target    = "integrations/${aws_apigatewayv2_integration.redirect_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.url_shortener_api.id
  name        = "prod"
  auto_deploy = true
}
