variable "domain_name" {
  description = "The domain name for which the ACM certificate will be created."
  type        = string
  default     = "novi-labs.infra.rnoel.net"
}

variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
  default     = "us-west-2"
}