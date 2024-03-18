resource "aws_lambda_function" "lambda" {
  function_name = var.function_name

  source_code_hash = base64sha256(data.archive_file.package.output_path)
  filename         = data.archive_file.package.output_path
  role             = aws_iam_role.role.arn

  handler     = "lambda_function.lambda_handler"
  runtime     = "python3.9"
  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      MATCH_STRING = var.match_substring
    }
  }

  tags = var.default_tags
}
