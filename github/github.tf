
# GitHub repository configuration.
# This Terraform file creates a personal access token-backed GitHub provider
# and provisions two private repositories for production and testing use.

# Required input: a GitHub personal access token used by the provider.
# The token is marked as sensitive so Terraform does not display it in logs.
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

# Configure the GitHub provider using the token supplied via variable input.
provider "github" {
  token = var.github_token
}

# Production repository.
# This repository is intended for the main application or deployment code.
resource "github_repository" "production-repo" {
  name             = "production-repo"
  description      = "A production repository created with Terraform"
  visibility       = "private"
  license_template = "mit"
}

# Testing repository.
# This repository is separate from production and can be used for test work.
resource "github_repository" "testing-repo" {
  name             = "testing-repo"
  description      = "A testing repository created with Terraform"
  visibility       = "private"
  license_template = "mit"
}
