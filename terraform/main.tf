data "aws_vpc" "selected" {
  id = var.vpc_id
}
 
 
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
 
# Manages the public subnets of the default VPC in the region
resource "aws_default_subnet" "default_az" {
  for_each          = toset(var.aws_zones)
  availability_zone = format("%s-%s", var.aws_region, each.value)
}
 
module "user_data" {
  for_each       = aws_default_subnet.default_az
  source         = "./modules/userdata"
  vpc_id         = data.aws_vpc.selected.id
  instance_count = var.instance_count
  ami            = data.aws_ami.ubuntu.id
  instance_type  = var.instance_type # Adjust as needed
  key_name       = var.key_name
  subnet_id      = each.value.id
  default_tags   = var.default_tags
 
}
 
resource "tls_private_key" "ssh_key" {
 algorithm = "RSA"
 rsa_bits  = 2048
}
resource "aws_key_pair" "ssh_key" {
 key_name   = "example-key"
 public_key = tls_private_key.ssh_key.public_key_openssh
}
