data "tfe_workspace" "current" {
  name         = var.TFC_WORKSPACE_NAME
  organization = var.organization
}
