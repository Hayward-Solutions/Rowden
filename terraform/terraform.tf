terraform {
  required_providers {
    aws = {
      version = "5.41.0"
    }
  }

  required_version = "= 1.7.5"
}


provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.role_arn
  }
}