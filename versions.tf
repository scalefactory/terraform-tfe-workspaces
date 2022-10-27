terraform {
  required_version = ">= 0.13.6, < 2.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.38.0"
    }
  }
}
