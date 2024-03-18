resource "aws_iam_role" "role" {
  name               = var.function_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.default_tags
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = data.aws_iam_policy.lambda_execution.arn
  role       = aws_iam_role.role.name
}

data "aws_iam_policy" "lambda_execution" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_role_policy_attachment" {
  role   = aws_iam_role.role.id
  name   = var.function_name
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:StopInstances"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      values   = ["*${var.match_substring}*"]
      variable = "aws:ResourceTag/Name"
    }
  }
}
