# Create and provision an AWS Lambda function with Terraform

This example deploys a Python 3.12 Lambda function and packages
[`lambda_function.py`](./lambda_function.py) into the ZIP archive required by
AWS. Terraform creates a dedicated IAM execution role with permission to write
logs only to this function's CloudWatch log group, which retains logs for 14
days. The function is not connected to an API Gateway, S3 bucket, or other
event source; it can be invoked directly with the AWS CLI.

## Prerequisites

- An AWS account and a region where Lambda is available.
- Terraform 1.5 or later and the AWS CLI.
- AWS credentials configured locally. Prefer an IAM Identity Center (SSO)
  profile or another short-lived credential source over long-lived access keys.
- AWS permissions to create and inspect Lambda functions, IAM roles and inline
  policies, and CloudWatch log groups.

Authenticate with the AWS CLI, for example:

```sh
aws configure sso
aws sso login --profile my-profile
aws sts get-caller-identity --profile my-profile
```

## Steps

1. Open a terminal in this directory:

   ```sh
   cd github/AWS/lambda
   ```

2. If using AWS SSO, select the profile for Terraform and AWS CLI:

   ```sh
   export AWS_PROFILE="my-profile"
   ```

3. Optionally customize the region, function name, timeout, or memory by
   creating a `terraform.tfvars` file:

   ```hcl
   aws_region      = "us-east-1"
   function_name   = "my-terraform-lambda"
   timeout_seconds = 10
   memory_size     = 128
   ```

4. Initialize Terraform, check the files, and preview what will be created:

   ```sh
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

   Terraform creates the ignored `lambda.zip` package from
   `lambda_function.py` during planning.

5. Deploy the function, IAM role, and log group:

   ```sh
   terraform apply
   ```

   Review the plan and type `yes` when prompted. Terraform prints the function
   name and ARN when deployment finishes.

6. Invoke the function directly and view its response:

   ```sh
   aws lambda invoke \
     --function-name "$(terraform output -raw function_name)" \
     --payload '{"source":"manual-test"}' \
     --cli-binary-format raw-in-base64-out \
     response.json
   cat response.json
   ```

   Invocation output appears in
   `/aws/lambda/<function-name>` in CloudWatch Logs. `response.json` is a local
   test artifact and should not be committed.

7. Remove the function, IAM role, and log group when finished:

   ```sh
   terraform destroy
   rm -f response.json
   ```

Terraform stores its state locally in this directory by default. Do not commit
state files, `terraform.tfvars`, or credentials; state can contain sensitive
infrastructure details.
