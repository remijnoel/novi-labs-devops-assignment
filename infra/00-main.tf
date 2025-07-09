module "naming" {
  source       = "./naming"
  project_name = "devops-assignment"
  environment  = "dev"
  repository   = "github.com/remijnoel/novi-labs-devops-assignment/infra"
}