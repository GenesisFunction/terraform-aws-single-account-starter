locals {
  common_tags = {
    Environment = var.env_name
    SourceRepo  = var.source_repo
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
    Terraform   = "true"
  }
}

