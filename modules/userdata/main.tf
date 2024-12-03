# This will convert the userdata into cloud-init format for cloud servers
data "cloudinit_config" "cloudinit_config" {
  gzip          = var.gzip
  base64_encode = var.base64_encode
  dynamic "part" {
    for_each = local.parts
    content {
      content_type = part.value["content_type"]
      content      = part.value["content"]
      merge_type   = "list(append)+dict(recurse_list)+str()"
    }
  }
}
 
 
# EC2 instances in public subnets
resource "aws_instance" "ubuntu_instances" {
 count         = var.instance_count
 ami           = var.ami
 instance_type = var.instance_type # Adjust as needed
 key_name      = aws_key_pair.ssh_key.key_name
 subnet_id     = var.subnet_id
 vpc_security_group_ids = [aws_security_group.ssh_access.id]
 user_data = jsonencode(local.parts)
}
 
# SSH key pair
resource "tls_private_key" "ssh_key" {
 algorithm = "RSA"
 rsa_bits  = 2048
}
resource "aws_key_pair" "ssh_key" {
 key_name   = "example-key"
 public_key = tls_private_key.ssh_key.public_key_openssh
}
 
# Security group for SSH access
resource "aws_security_group" "ssh_access" {
 name        = "allow_ssh"
 description = "Allow SSH access"
 vpc_id      = var.vpc_id
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
