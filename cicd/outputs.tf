output "role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "The ARN of the IAM role for GitHub Actions." 
}