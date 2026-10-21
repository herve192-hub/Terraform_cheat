# Display the deployed function name for AWS CLI commands.
output "function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.example.function_name
}

# Display the ARN for referencing this function from other AWS resources.
output "function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = aws_lambda_function.example.arn
}

# Display the CloudWatch log group where invocation output is stored.
output "log_group_name" {
  description = "CloudWatch log group name for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda.name
}
