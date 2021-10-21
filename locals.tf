locals {
  # Complete path of the Github repo backing these workspaces
  vcs_identifier = "${var.vcs_org}/${var.vcs_repo}"
  # Resolve current workspace Terraform version, if not specified
  tf_version = var.tf_version != null ? var.tf_version : data.tfe_workspace.current.terraform_version
}
