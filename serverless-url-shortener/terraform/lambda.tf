resource "aws_lambda_function" "create_short_url" {
  filename         = "lambda/create.zip"
  function_name    = "CreateShortURL"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "create.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda/create.zip")
  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
      BASE_URL   = "${aws_apigatewayv2_api.url_shortener_api.api_endpoint}/${aws_apigatewayv2_stage.default.name}"
    }
  }
}

resource "aws_lambda_function" "redirect_url" {
  filename         = "lambda/redirect.zip"
  function_name    = "RedirectURL"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "redirect.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda/redirect.zip")
  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }
}

resource "aws_lambda_permission" "apigw_permission_create" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_short_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.url_shortener_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_permission_redirect" {
  statement_id  = "AllowAPIGatewayInvokeRedirect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.url_shortener_api.execution_arn}/*/*"
}