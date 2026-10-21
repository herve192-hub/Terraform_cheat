terraform {
  # Require Terraform features available in 1.5 and later.
  required_version = ">= 1.5.0"

  # Use the GitHub provider to create and configure the repository.
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # The provider reads GITHUB_TOKEN from the environment; never put tokens here.
  # Select a personal account or an organization based on the owner-type input.
  owner = var.repository_owner_type == "organization" ? var.organization_name : var.github_username
}

# Create a repository initialized with a README, MIT license, and Terraform .gitignore.
resource "github_repository" "managed" {
  name        = var.repository_name
  description = var.repository_description
  visibility  = var.repository_visibility

  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"

  # Enable common collaboration and security features.
  has_issues             = true
  has_projects           = false
  has_wiki               = false
  delete_branch_on_merge = true

  # Keep merge history consistent and require pull requests for collaboration.
  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true

  topics = var.repository_topics
}

# Enable GitHub's dependency vulnerability alerts for the repository.
resource "github_repository_vulnerability_alerts" "managed" {
  repository = github_repository.managed.name
  enabled    = true
}

# Ensure the repository uses the selected default branch name.
resource "github_branch_default" "managed" {
  repository      = github_repository.managed.name
  branch          = var.default_branch
  rename          = true
  wait_for_rename = true
}

# Apply protection rules to the repository's default branch.
resource "github_repository_ruleset" "default_branch" {
  name        = "Protect default branch"
  repository  = github_repository.managed.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      # Protect the branch managed by github_branch_default.
      include = ["refs/heads/${var.default_branch}"]
      exclude = []
    }
  }

  rules {
    # Prevent deleting or force-pushing the protected branch.
    deletion         = true
    non_fast_forward = true

    # Require pull requests and the configured number of approvals.
    pull_request {
      dismiss_stale_reviews_on_push     = true
      required_approving_review_count   = var.required_approving_review_count
      required_review_thread_resolution = true
    }
  }

  depends_on = [github_branch_default.managed]
}
