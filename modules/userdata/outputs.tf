output "public_key" {
  value = aws_key_pair.ssh_key.public_key
}
 
output "user_data" {
  value       = data.cloudinit_config.cloudinit_config.rendered
  description = "User data as string"
}
