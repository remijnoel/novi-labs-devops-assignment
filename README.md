# novi-labs-devops-assignment

## First deployment (initial setup)

```shell
terraform init
terraform apply -target aws_route53_zone.novi_labs
# Once the DNS zone is created, you can add the NS records to the proper parent zone
terraform apply
```
