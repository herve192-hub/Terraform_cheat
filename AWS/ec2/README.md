# Create and provision an EC2 instance with Terraform

This example creates an Amazon Linux 2023 EC2 instance in the region's default
VPC, installs Apache with EC2 user data, and allows inbound HTTP on port 80.
It does not open SSH to the internet. The instance and its root volume are
configured to require IMDSv2 and use encryption, respectively.

## Prerequisites

- An AWS account and a region with a default VPC and at least one subnet.
- Terraform 1.5 or later.
- AWS CLI credentials configured locally. Prefer an IAM Identity Center
  (SSO) profile or another short-lived credential source over long-lived keys.
- AWS permissions to read the selected region's VPC, subnets, and public
  Amazon Linux SSM parameter, and to create EC2 instances and security groups.

Authenticate with the AWS CLI, for example:

```sh
aws configure sso
aws sso login --profile my-profile
aws sts get-caller-identity --profile my-profile
```

## Steps

1. Open a terminal in this directory:

   ```sh
   cd github/AWS
   ```

2. Initialize Terraform and download the AWS provider:

   ```sh
   terraform init
   ```

3. Optionally choose a region, instance size, or instance name by creating
   `terraform.tfvars`:

   ```hcl
   aws_region   = "us-east-1"
   instance_type = "t3.micro"
   instance_name = "my-web-server"
   ```

   Set the profile in your shell if you are using AWS SSO:

   ```sh
   export AWS_PROFILE="my-profile"
   ```

4. Check the configuration and preview the resources:

   ```sh
   terraform fmt -check
   terraform validate
   terraform plan
   ```

5. Create the instance and its security group:

   ```sh
   terraform apply
   ```

   Review the plan and type `yes` when prompted. Terraform will print the
   instance ID, public IP, and website URL when the apply completes.

6. Open the printed `website_url` in a browser. Apache may take a minute to
   finish installing after the instance starts.

7. Delete the resources when you are finished to avoid ongoing AWS charges:

   ```sh
   terraform destroy
   ```

Terraform stores its state locally in this directory by default. Do not commit
state files or credentials; state can contain sensitive infrastructure data.
