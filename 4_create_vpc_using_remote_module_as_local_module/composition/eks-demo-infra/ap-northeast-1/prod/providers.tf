########################################
# Provider to connect to AWS
# https://www.terraform.io/docs/providers/aws/
########################################

terraform {
  required_version = ">1.0"
  backend "s3" {} # use backend.config for remote backend

  required_providers {
    aws    = "> 4.0"
    random = "> 2"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}
