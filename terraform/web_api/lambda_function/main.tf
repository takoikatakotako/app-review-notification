##################################################
# Lambda
##################################################
resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  role             = var.role
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 3
  filename         = data.archive_file.python_script_archive_file.output_path
  source_code_hash = data.archive_file.python_script_archive_file.output_base64sha256

  environment {
    variables = {
      DISCORD_WEBHOOK_URL = "xxx"
    }
  }
}

data "archive_file" "python_script_archive_file" {
  type        = "zip"
  output_path = "${path.module}/output/${var.archive_filename}"

  source {
    content  = data.template_file.python_script_file.rendered
    filename = "lambda_function.py"
  }
}

data "template_file" "python_script_file" {
  template = file("${path.module}/script/${var.filename}")
}


resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "api-gateway-${var.function_name}-statement-id"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  source_arn = "${var.execution_arn}/*/${var.method}${var.path}"
}
