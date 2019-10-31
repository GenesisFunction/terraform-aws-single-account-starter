locals {
  common_tags = {
    Environment = var.env_name
    RepoName    = var.repo_name
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
    Terraform   = "true"
  }
}

