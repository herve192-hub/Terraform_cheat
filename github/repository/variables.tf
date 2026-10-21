# Select whether Terraform should create the repository under a personal account or organization.
variable "repository_owner_type" {
  description = "Whether the repository belongs to a personal user account or an organization"
  type        = string
  default     = "user"

  validation {
    condition     = contains(["user", "organization"], var.repository_owner_type)
    error_message = "Repository owner type must be either user or organization."
  }
}

# GitHub username used when repository_owner_type is user.
variable "github_username" {
  description = "GitHub username that owns the repository when owner type is user"
  type        = string
  default     = ""

  validation {
    condition     = var.repository_owner_type != "user" || length(trimspace(var.github_username)) > 0
    error_message = "Set github_username when repository_owner_type is user."
  }
}

# GitHub organization slug used when repository_owner_type is organization.
variable "organization_name" {
  description = "GitHub organization name that owns the repository when owner type is organization"
  type        = string
  default     = ""

  validation {
    condition     = var.repository_owner_type != "organization" || length(trimspace(var.organization_name)) > 0
    error_message = "Set organization_name when repository_owner_type is organization."
  }
}

# Repository names must be unique within the selected owner.
variable "repository_name" {
  description = "Name of the new GitHub repository"
  type        = string

  validation {
    condition     = length(var.repository_name) >= 1 && length(var.repository_name) <= 100
    error_message = "Repository name must be between 1 and 100 characters."
  }
}

# Choose private by default; make public only when repository contents are safe to disclose.
variable "repository_visibility" {
  description = "Repository visibility: private or public"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.repository_visibility)
    error_message = "Repository visibility must be either private or public."
  }
}

# Short description shown on the GitHub repository page.
variable "repository_description" {
  description = "Description shown on the GitHub repository page"
  type        = string
  default     = "Managed with Terraform"
}

# GitHub topic labels used to categorize the repository.
variable "repository_topics" {
  description = "Topic labels to apply to the repository"
  type        = list(string)
  default     = ["terraform"]
}

# Name of the branch to create or make the repository's default branch.
variable "default_branch" {
  description = "Default branch name protected by the ruleset"
  type        = string
  default     = "main"

  validation {
    condition     = can(regex("^[A-Za-z0-9._/-]+$", var.default_branch)) && !startswith(var.default_branch, "/") && !endswith(var.default_branch, "/") && !strcontains(var.default_branch, "..")
    error_message = "Use a valid branch name containing letters, numbers, dots, underscores, hyphens, or slashes."
  }
}

# A value of 1 requires another collaborator to review each pull request.
variable "required_approving_review_count" {
  description = "Number of approvals required before merging into the default branch"
  type        = number
  default     = 1

  validation {
    condition     = var.required_approving_review_count >= 0 && var.required_approving_review_count <= 6 && var.required_approving_review_count % 1 == 0
    error_message = "Required approvals must be a whole number from 0 through 6."
  }
}
