terraform {
  # Require Terraform features available in 1.5 and later.
  required_version = ">= 1.5.0"

  # Pin the AWS provider to compatible v5 releases.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # The region can be changed with the aws_region input variable.
  region = var.aws_region
}

# Create a private S3 bucket. Bucket names must be globally unique across AWS.
resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "learning"
  }
}

# Keep all four S3 public-access protections enabled for this bucket.
resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply S3-managed server-side encryption to new objects.
resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Ensure the bucket owner owns uploaded objects and ACLs are disabled.
resource "aws_s3_bucket_ownership_controls" "storage" {
  bucket = aws_s3_bucket.storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
