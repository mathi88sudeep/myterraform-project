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