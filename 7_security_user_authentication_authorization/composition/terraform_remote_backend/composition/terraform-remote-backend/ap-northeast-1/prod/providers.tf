########################################
# Provider to connect to AWS
#
# https://www.terraform.io/docs/providers/aws/
########################################

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws    = "> 4.0"
    random = "~> 2"
  }

  # backend "s3" {} # use local backend to first create S3 bucket to store .tfstate later
}

provider "aws" {
  region  = var.region
  profile = var.profile_name
}
