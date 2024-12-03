variable "gzip" {
  type        = bool
  default     = true
  description = "Compress UserData so we can fit in large scripts"
}
 
variable "base64_encode" {
  type        = bool
  default     = true
  description = "Must be true is gzip is true"
}
 
variable "startup" {
  type        = string
  default     = "/opt/terraform-cicd-test/ansible/startup.yml"
  description = "The default location of the ansible file to run"
}
 
variable "ansible_git" {
  type        = string
  default     = "https://bitbucket.org/trustypangolin/terraform-cicd-test.git"
  description = "Clone your forked repo and set this variable"
}
 
locals {
  run_part = [{
    content_type = "text/cloud-config",
    content = join("\n", [
      "package_update: true"
      , "package_upgrade: true"
 
      , "packages:"
      , "- git"
      , "- ansible"
 
      , "runcmd:"
      , "- git config --global user.name 'playbook' git config --global user.email 'playbook@email.com'"
      , "- cd /opt"
      , "- git clone ${var.ansible_git}"
      , "- ansible-playbook ${var.startup}"
      ]
    )
  }]
 
  parts = concat(
    local.run_part,
  )
}
 
 
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
 
variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}
 
variable "instance_count" {
  description = "No of EC2 Instance to provision"
  type        = number
}
 
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}
 
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}
 
variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}
 
variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}
 
variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
}
 
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
 
variable "aws_zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}
 
terraform.tf
 
terraform {
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}
 

