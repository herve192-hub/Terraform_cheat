# Create and provision an S3 bucket with Terraform

This example creates a private S3 bucket. It blocks public access, encrypts new
objects with S3-managed keys, and enforces bucket-owner ownership with ACLs
disabled. It does not create a public website or upload files automatically.

## Prerequisites

- An AWS account and a region where you can create S3 buckets.
- Terraform 1.5 or later and the AWS CLI.
- AWS credentials configured locally. Prefer an IAM Identity Center (SSO)
  profile or another short-lived credential source over long-lived access keys.
- AWS permissions to create and inspect S3 buckets and configure public access,
  encryption, and ownership controls.

Authenticate with the AWS CLI, for example:

```sh
aws configure sso
aws sso login --profile my-profile
aws sts get-caller-identity --profile my-profile
```

## Steps

1. Open a terminal in this directory:

   ```sh
   cd github/AWS/s3
   ```

2. Set the AWS profile if using SSO:

   ```sh
   export AWS_PROFILE="my-profile"
   ```

3. Choose a globally unique bucket name. Bucket names are shared across AWS,
   so replace the example below with a name that is not already in use:

   ```sh
   cat > terraform.tfvars <<'EOF'
   aws_region = "us-east-1"
   bucket_name = "my-unique-terraform-bucket-12345"
   EOF
   ```

4. Initialize Terraform, check formatting and configuration, and preview the
   resources:

   ```sh
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

5. Create the bucket and its security settings:

   ```sh
   terraform apply
   ```

   Review the plan and type `yes` when prompted. Terraform prints the bucket
   name, ARN, and regional endpoint.

6. Optionally upload a file. Replace `./example.txt` with a file on your
   computer and use the bucket name printed by Terraform:

   ```sh
   aws s3 cp ./example.txt s3://my-unique-terraform-bucket-12345/
   ```

7. When finished, remove any uploaded objects and destroy the bucket:

   ```sh
   aws s3 rm s3://my-unique-terraform-bucket-12345/ --recursive
   terraform destroy
   ```

Terraform stores its state locally in this directory by default. Do not commit
state files, `terraform.tfvars`, or credentials; state may contain sensitive
infrastructure details.
