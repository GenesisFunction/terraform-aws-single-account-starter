locals {
  common_tags = {
    Environment = var.env_name
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
    Terraform   = "true"
  }
}

