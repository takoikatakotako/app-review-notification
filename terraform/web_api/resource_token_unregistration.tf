# ##################################################
# # API Gateway
# ##################################################
# resource "aws_api_gateway_resource" "token_unregistration_resource" {
#   rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id
#   parent_id   = aws_api_gateway_resource.token_resource.id
#   path_part   = "unregistration"
# }

# resource "aws_api_gateway_method" "token_unregistration_post_method" {
#   rest_api_id   = aws_api_gateway_rest_api.app_review_rest_api.id
#   resource_id   = aws_api_gateway_resource.token_unregistration_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "token_unregistration_post_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.app_review_rest_api.id
#   resource_id             = aws_api_gateway_resource.token_unregistration_resource.id
#   http_method             = aws_api_gateway_method.token_unregistration_post_method.http_method
#   type                    = "AWS_PROXY"
#   content_handling        = "CONVERT_TO_TEXT"
#   integration_http_method = "POST"
#   uri                     = module.token_unregistration_post_lambda_function.invoke_arn
#   cache_key_parameters    = []
#   request_parameters      = {}
#   request_templates       = {}
# }

# resource "aws_api_gateway_method_response" "token_unregistration_post_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id
#   resource_id = aws_api_gateway_resource.token_unregistration_resource.id
#   http_method = aws_api_gateway_method.token_unregistration_post_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = false
#   }
# }

# resource "aws_api_gateway_integration_response" "token_unregistration_post_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id
#   resource_id = aws_api_gateway_resource.token_unregistration_resource.id
#   http_method = aws_api_gateway_method.token_unregistration_post_method.http_method
#   status_code = aws_api_gateway_method_response.token_unregistration_post_method_response.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }

#   response_templates = {
#     "application/json" = ""
#   }
# }

# # Options
# module "token_unregistration_options_method" {
#   source      = "./options_method"
#   rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id
#   resource_id = aws_api_gateway_resource.token_unregistration_resource.id
# }

# ##################################################
# # Lambda
# ##################################################
# module "token_unregistration_post_lambda_function" {
#   source           = "./lambda_function"
#   function_name    = "token-unregistration-get-function"
#   role             = aws_iam_role.api_gateway_lambda_role.arn
#   filename         = "unregistration_function.py"
#   archive_filename = "unregistration_function_archive_file.zip"
#   execution_arn    = aws_api_gateway_rest_api.app_review_rest_api.execution_arn
#   method           = "POST"
#   path             = "/token/unregistration"
# }
