# connect terraform provider to azure, aws, gcp and github
# using aws IAM credentials, azure service principal, gcp service account and github personal access token  


# aws console-> IAM -> Users -> Add user 
# -> Programmatic access -> Attach existing policies directly 
# -> AdministratorAccess/amazonVPCFullAccess/... -> Create user
# aws configure security credentials (access key id and secret access key) in your local machine
# create access key and secret access key for your aws user and save it in your local machine

# in your local terminal, run the following command to configure aws credentials
# on linux: export AWS_ACCESS_KEY_ID="your_access_key_id"
#           export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
#           export AWS_DEFAULT_REGION="your_aws_region"


# on windows: setx AWS_ACCESS_KEY_ID "your_access_key_id"
#             setx AWS_SECRET_ACCESS_KEY "your_secret_access_key"  
#             setx AWS_DEFAULT_REGION "your_aws_region"
#           OR
#            $Env:AWS_ACCESS_KEY_ID="your_access_key_id"
#            $Env:AWS_SECRET_ACCESS_KEY="your_secret_access_key"
#            $Env:AWS_DEFAULT_REGION="your_aws_region"

# on mac: export AWS_ACCESS_KEY_ID="your_access_key_id"
#         export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
#         export AWS_DEFAULT_REGION="your_aws_region"


# azure console -> Azure Active Directory -> App registrations -> New registration
# -> Name: terraform-azure-provider -> Supported account types: Accounts in this organizational directory only
# -> Redirect URI (optional): http://localhost:8080 -> Register
# -> Certificates & secrets -> New client secret -> Copy the value of the client secret and save it in your local machine
# -> Overview -> Application (client) ID and Directory (tenant)

# in your local terminal, run the following command to configure azure credentials
# on linux: export ARM_CLIENT_ID="your_application_client_id"
#           export ARM_CLIENT_SECRET="your_client_secret"
#           export ARM_SUBSCRIPTION_ID="your_subscription_id"
#           export ARM_TENANT_ID="your_directory_tenant_id"
# 
# on windows: setx ARM_CLIENT_ID "your_application_client_id"
#             setx ARM_CLIENT_SECRET "your_client_secret"
#             setx ARM_SUBSCRIPTION_ID "your_subscription_id"
#             setx ARM_TENANT_ID "your_directory_tenant_id"
#           OR
#            $Env:ARM_CLIENT_ID="your_application_client_id"
#            $Env:ARM_CLIENT_SECRET="your_client_secret"
#            $Env:ARM_SUBSCRIPTION_ID="your_subscription_id"
#            $Env:ARM_TENANT_ID="your_directory_tenant_id"
# 
# on mac: export ARM_CLIENT_ID="your_application_client_id"
#         export ARM_CLIENT_SECRET="your_client_secret"
#         export ARM_SUBSCRIPTION_ID="your_subscription_id"
#         export ARM_TENANT_ID="your_directory_tenant_id"   



# gcp console -> IAM & Admin -> Service accounts -> Create service account
# -> Service account name: terraform-gcp-provider -> Service account ID: terraform-gcp-provider
# -> Service account permissions: Project -> Owner -> Continue -> Done
# -> IAM & Admin -> Service accounts -> terraform-gcp-provider -> Keys -> Add key -> Create new key -> JSON -> Create -> Save the JSON file in your local machine   
# in your local terminal, run the following command to configure gcp credentials
# on linux: export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/service-account-file.json"
# on windows: setx GOOGLE_APPLICATION_CREDENTIALS "path/to/your/service-account-file.json"
#           OR
#            $Env:GOOGLE_APPLICATION_CREDENTIALS="path/to/your/service-account-file.json"
# on mac: export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/service-account-file.json"


# github console -> Settings -> Developer settings -> Personal access tokens -> Tokens (classic) -> Generate new token
# -> Note: terraform-github-provider -> Expiration: No expiration -> Select scopes: repo
# -> Generate token -> Copy the token and save it in your local machine
# in your local terminal, run the following command to configure github credentials
# on linux: export GITHUB_TOKEN="your_personal_access_token"
# on windows: setx GITHUB_TOKEN "your_personal_access_token"
#           OR
#            $Env:GITHUB_TOKEN="your_personal_access_token" 
# on mac: export GITHUB_TOKEN="your_personal_access_token"




# run the following command to initialize terraform providers
# 
# terraform init
# 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Provider configuration examples.
# Terraform reads AWS, Azure, GCP, and GitHub credentials from the environment
# variables configured above, so no secrets are hard-coded here.

provider "aws" {
  region = "us-east-1" # set AWS_DEFAULT_REGION for your environment
  # Uses AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
}

provider "azurerm" {
  features {}
  # Uses ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, and ARM_TENANT_ID
}

provider "google" {
  project = "your-gcp-project-id" # set your GCP project ID
  # Uses GOOGLE_APPLICATION_CREDENTIALS
}

provider "github" {
  owner = "your-github-username-or-org"
  # Uses GITHUB_TOKEN
}
