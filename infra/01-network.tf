module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${module.naming.prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.128.0/24", "10.0.129.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = module.naming.tags
}