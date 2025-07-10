module "naming" {
  source       = "./naming"
  project_name = "devops-assignment"
  environment  = terraform.workspace == "default" ? "dev" : terraform.workspace
  repository   = "github.com/remijnoel/novi-labs-devops-assignment/infra"
}