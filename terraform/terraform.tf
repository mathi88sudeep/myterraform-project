terraform {
  required_version = "~> 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  type        = string
  description = "Default AWS region"
}

variable "aws_zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Returns the Default VPC in the Region
data "aws_vpc" "selected" {
  default = true
}

# Manages the public subnets of the default VPC in the region
resource "aws_default_subnet" "default_az" {
  for_each          = toset(var.aws_zones)
  availability_zone = format("%s%s", var.aws_region, each.value)
}

# outputs the CIDR of each public Subnet in the default VPC in the region
output "subnet_cidr_blocks" {
  value = [for s in aws_default_subnet.default_az : s.cidr_block]
}

# This outputs the user_data string
output "user_data" {
  value = module.user_data.user_data
}