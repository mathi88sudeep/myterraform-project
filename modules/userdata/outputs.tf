output "user_data" {
  value       = data.cloudinit_config.cloudinit_config.rendered
  description = "User data as string"
}
