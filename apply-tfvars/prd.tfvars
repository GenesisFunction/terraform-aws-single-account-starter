# These variables are called when running the following command:
# terraform apply -var-file ./apply-tfvars/prd.tfvars

currency = "USD"
env_name = "prd"
monthly_billing_threshold = "500"
name_prefix = "customer"
region = "us-east-1"
source_repo = "https://github.com/StratusGrid/terraform-aws-single-account-starter"