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
