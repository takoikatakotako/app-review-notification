module "registration_function" {
  source           = "./lambda_function"
  function_name    = "registration-function"
  role             = aws_iam_role.lambda_role.arn
  filename         = "registration_function.py"
  archive_filename = "registration_function_archive_file.zip"
}

module "unregistration_function" {
  source           = "./lambda_function"
  function_name    = "unregistration-function"
  role             = aws_iam_role.lambda_role.arn
  filename         = "unregistration_function.py"
  archive_filename = "unregistration_function_archive_file.zip"
}



resource "aws_api_gateway_rest_api" "app_review_rest_api" {
  name = "app-review-api"
}

resource "aws_api_gateway_deployment" "app_review_deployment" {
  rest_api_id = aws_api_gateway_rest_api.app_review_rest_api.id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      triggers
    ]
  }
}


resource "aws_api_gateway_stage" "app_review_stage" {
  deployment_id = aws_api_gateway_deployment.app_review_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.app_review_rest_api.id
  stage_name    = "production"
  tags          = {}
  variables     = {}
  lifecycle {
    ignore_changes = [
      deployment_id # deploy は何回も作り直されるため
    ]
  }
}


# terraform import module.web_api.aws_api_gateway_stage.app_review_stage lleh796zq8/production

# terraform import module.web_api.aws_api_gateway_resource.token_resource lleh796zq8/f8anq8


# ## UNAUTHORIZED
# resource "aws_api_gateway_gateway_response" "turnip_unauthorized_response" {
#   rest_api_id   = aws_api_gateway_rest_api.turnip_api.id
#   status_code   = "401"
#   response_type = "UNAUTHORIZED"

#   response_templates = {
#     "application/json" = "{\"message\":$context.error.messageString}"
#   }

#   response_parameters = {}
# }
