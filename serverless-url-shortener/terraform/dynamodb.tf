resource "aws_dynamodb_table" "short_urls" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "shortId"

  attribute {
    name = "shortId"
    type = "S"
  }

}
