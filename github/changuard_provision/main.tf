terraform {
  required_providers {
    github = {
      source  = "github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = "ChangeGuardHQ"
}

resource "github_repository" "changuard_platform" {
  name       = "changuard-platform"
  visibility = "private"
  auto_init  = true # initialize the repository with a README file
}
