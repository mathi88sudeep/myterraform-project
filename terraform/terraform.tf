terraform {
  required_version = ">=1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
 
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.default_tags
  }
# shared_credentials_files = [ "~/.aws/credentials" ]
  assume_role {
    role_arn = "arn:${var.partition}:iam::${var.account_no}:role/${var.deployment_role}"
  }
}
