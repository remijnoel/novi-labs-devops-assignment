# 1. GitHub OIDC Identity Provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
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

# 4. Attach AWS Managed Policy or custom permissions
resource "aws_iam_role_policy_attachment" "github_actions_attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"  # TODO should be more restrictive
}
resource "aws_iam_role_policy_attachment" "github_actions_attach_ecr_policy" {
    role       = aws_iam_role.github_actions_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess" # TODO should be more restrictive
}