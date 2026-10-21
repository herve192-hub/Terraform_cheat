# Show the name needed for AWS CLI uploads and other bucket operations.
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.storage.id
}

# Show the bucket ARN for use in IAM policies and other AWS resources.
output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.storage.arn
}

# Show the region-specific endpoint for the bucket.
output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.storage.bucket_regional_domain_name
}
