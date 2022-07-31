# DynamoDB
resource "aws_dynamodb_table" "news_table" {
  name           = "slack-table"
  hash_key       = "slackToken"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  stream_enabled = false

  attribute {
    name = "slackToken"
    type = "S"
  }
}
