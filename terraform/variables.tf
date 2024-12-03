variable "aws_region" {
  type        = string
  description = "Default AWS region"
}
 
variable "aws_zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}
 
variable "instance_count" {
  description = "No of EC2 Instance to provision"
  type        = number
  default = 3
}
 
variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}
 
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
 
variable "partition" {
  type        = string
  default     = "aws"
  description = "Second part of aws arn. Used only in the provider configuration."
}
 
variable "deployment_role" {
  description = "Terraform Deployment Role"
  type        = string
}
 
variable "account_no" {
  description = "AWS account number to deploy to"
  type        = string
}
 
variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
}
 
variable "admin_role" {
  type        = string
  description = "role for the admin"
}
 
variable "iam_user" {
  type        = string
  description = "role to assume when deploying"
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
 
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
