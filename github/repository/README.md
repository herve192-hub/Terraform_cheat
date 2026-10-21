# Create and configure a GitHub repository with Terraform

This example creates a GitHub repository with a README, MIT license, and
Terraform `.gitignore`. It defaults to private visibility, enables
vulnerability alerts, selects `main` as the default branch, and protects it
with a ruleset that blocks deletion and force pushes and requires pull requests
and review-thread resolution. By default, pull requests need one approval.

The ruleset does not require named CI status checks because this example does
not create a CI workflow. It does not add collaborators or organization teams;
repository visibility and access to its owner are separate from branch rules.

## Prerequisites

- A GitHub account or organization where you are allowed to create repositories.
- Terraform 1.5 or later.
- A GitHub personal access token with repository administration permissions
  (for example, the `repo` scope for a classic token). Organization policies may
  require an organization-approved token or additional permissions.
- GitHub provider access to create repositories and manage repository rulesets.
  Ruleset availability can depend on the GitHub plan, especially for private
  organization repositories.
- For an organization repository, an organization owner may need to approve the
  token or grant the account the required repository administration role.

Set the token in your terminal, not in Terraform configuration:

```sh
export GITHUB_TOKEN="your-token"
```

## Steps

1. Open a terminal in this directory:

   ```sh
   cd github/repository
   ```

2. Create your local variable file from the provided example and edit the
   owner type, owner name, repository name, visibility, default branch, and
   approval requirement:

   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```

   For a personal repository, set:

   ```hcl
   repository_owner_type = "user"
   github_username       = "your-github-username"
   ```

   For a repository owned by an organization, set:

   ```hcl
   repository_owner_type = "organization"
   organization_name     = "your-github-organization"
   ```

   Terraform uses a conditional expression to select the matching owner for
   the GitHub provider. Only the selected owner value is required.

   The example defaults to a private repository and one required reviewer.
   Set `repository_visibility = "public"` only if the repository contents are
   safe to make public. If you are the only contributor, set
   `required_approving_review_count = 0` so you can merge your own pull
   requests.

3. Initialize Terraform and verify the configuration:

   ```sh
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

   Review the plan carefully. Changing a repository's visibility can expose
   all of its contents or restrict access; check the planned visibility before
   applying.

4. Create the repository and default-branch ruleset:

   ```sh
   terraform apply
   ```

   Confirm the plan when prompted. Terraform prints the repository URL and
   default branch.

5. To remove the repository and its ruleset:

   ```sh
   terraform destroy
   ```

   Destroying the repository deletes its hosted contents. Make a backup first
   if you need to keep the files.

Terraform stores its state locally in this directory by default. Do not commit
state files, `terraform.tfvars`, or credentials; state contains repository
metadata and can contain sensitive information.
