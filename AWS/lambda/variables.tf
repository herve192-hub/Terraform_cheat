# AWS region in which to create the Lambda function and its related resources.
variable "aws_region" {
  description = "AWS region in which to create the Lambda function"
  type        = string
  default     = "us-east-1"
}

# Lambda function names must be unique within the AWS account and region.
variable "function_name" {
  description = "Name for the Lambda function and its related IAM role"
  type        = string
  default     = "terraform-example-lambda"

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,64}$", var.function_name))
    error_message = "Use 1-64 letters, numbers, hyphens, or underscores for the function name."
  }
}

# Configure the maximum run duration for each function invocation.
variable "timeout_seconds" {
  description = "Maximum number of seconds for each invocation"
  type        = number
  default     = 10

  validation {
    condition     = var.timeout_seconds >= 1 && var.timeout_seconds <= 900
    error_message = "Lambda timeout must be between 1 and 900 seconds."
  }
}

# Configure the memory allocated to each function invocation.
variable "memory_size" {
  description = "Memory allocated to the Lambda function in MB"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240 && var.memory_size % 1 == 0
    error_message = "Lambda memory must be a whole number between 128 and 10240 MB."
  }
}
