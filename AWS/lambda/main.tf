terraform {
  # Require Terraform features available in 1.5 and later.
  required_version = ">= 1.5.0"

  # Use the AWS provider to provision Lambda and its IAM and logging resources.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

provider "aws" {
  # The region can be changed with the aws_region input variable.
  region = var.aws_region
}

# Package the Python handler into the ZIP file AWS Lambda expects.
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda.zip"
}

# Let the Lambda service assume the execution role.
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create a dedicated execution role for this function.
resource "aws_iam_role" "lambda" {
  name               = "${var.function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Retain function logs for two weeks instead of keeping them indefinitely.
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

# Grant the function permission to write logs only to its own log group.
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }
}

resource "aws_iam_role_policy" "lambda_logging" {
  name   = "${var.function_name}-logging"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_logging.json
}

# Deploy the packaged Python handler and its least-privilege execution role.
resource "aws_lambda_function" "example" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  timeout          = var.timeout_seconds
  memory_size      = var.memory_size

  # Create logging infrastructure and permissions before deploying the function.
  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy.lambda_logging,
  ]

  tags = {
    Name        = var.function_name
    Environment = "learning"
  }
}
