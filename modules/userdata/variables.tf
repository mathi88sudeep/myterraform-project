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