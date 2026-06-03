terraform {
  required_version = "1.15.5"

  cloud {
    
    organization = "Nique-cloud"

    workspaces {
      name = "Terraform-deploy"
    }
  }
}
