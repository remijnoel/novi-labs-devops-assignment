# 1. GitHub OIDC Identity Provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
}

# 2. IAM Role Trust Policy (Assumable by GitHub Actions)
data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:remijnoel/novi-labs-devops-assignment:ref:refs/heads/*"
      ]
    }
  }
}

# 3. IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name               = "novi-labs-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

# Need admin permissions to deploy the terraform template
# This could be restricted to only the necessary permissions to create the resources
# in the template, but for simplicity, we use AWSAdministratorAccess for this example.
resource "aws_iam_role_policy_attachment" "github_actions_attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}