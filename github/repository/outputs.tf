# Display the new repository's canonical URL.
output "repository_url" {
  description = "HTTPS URL of the created repository"
  value       = github_repository.managed.html_url
}

# Display the selected personal account or organization that owns the repository.
output "repository_owner" {
  description = "GitHub account or organization that owns the repository"
  value       = var.repository_owner_type == "organization" ? var.organization_name : var.github_username
}

# Display the default branch name protected by the ruleset.
output "default_branch" {
  description = "Default branch name for the repository"
  value       = github_branch_default.managed.branch
}

# Display the ruleset identifier for reference in GitHub.
output "default_branch_ruleset_id" {
  description = "ID of the default-branch protection ruleset"
  value       = github_repository_ruleset.default_branch.id
}
