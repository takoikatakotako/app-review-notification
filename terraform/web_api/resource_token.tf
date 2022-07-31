##################################################
# API Gateway
##################################################
resource "aws_api_gateway_resource" "token_resource" {
  rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id
  parent_id   = aws_api_gateway_rest_api.app_review_rest_api.root_resource_id
  path_part   = "token"
}

