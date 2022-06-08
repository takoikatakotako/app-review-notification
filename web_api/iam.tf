resource "aws_iam_role" "api_gateway_lambda_role" {
  name               = "api-gateway-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "api_gateway_lambda_role_policy" {
  name   = "api-gateway-lambda-role-policy"
  policy = data.aws_iam_policy_document.api_gateway_lambda_role_policy_document.json
}

data "aws_iam_policy_document" "api_gateway_lambda_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "dynamodb:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "api_gateway_lambda_role_policy_attachment" {
  role       = aws_iam_role.api_gateway_lambda_role.name
  policy_arn = aws_iam_policy.api_gateway_lambda_role_policy.arn
}