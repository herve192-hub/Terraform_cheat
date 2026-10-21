# AWS region where the S3 bucket will be created.
variable "aws_region" {
  description = "AWS region in which to create the S3 bucket"
  type        = string
  default     = "us-east-1"
}

# S3 bucket names are shared globally, so provide a unique lowercase name.
variable "bucket_name" {
  description = "Globally unique S3 bucket name using lowercase letters, numbers, and hyphens"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Use 3-63 lowercase letters, numbers, or hyphens; the name must start and end with a letter or number."
  }
}
