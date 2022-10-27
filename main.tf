# Individual workspace
resource "tfe_workspace" "workspace" {
  for_each = var.workspaces

  name                          = each.key
  description                   = "Workspace: ${each.key} | Triggered from path: ${each.value}"
  allow_destroy_plan            = true
  organization                  = var.organization
  terraform_version             = local.tf_version
  working_directory             = each.value
  file_triggers_enabled         = true
  auto_apply                    = false
  execution_mode                = var.execution_mode
  structured_run_output_enabled = var.structured_run_output_enabled
  assessments_enabled           = var.assessments_enabled
  speculative_enabled           = var.speculative_enabled
  tag_names                     = var.tag_names

  vcs_repo {
    # branch         = "main"
    identifier     = local.vcs_identifier
    oauth_token_id = var.oauth_token_id
  }
}

# Slack notification
resource "tfe_notification_configuration" "slack" {
  for_each = var.slacks

  name             = each.value.name
  enabled          = each.value.enabled
  destination_type = "slack"
  triggers         = ["run:created", "run:planning", "run:needs_attention", "run:applying", "run:completed", "run:errored"]
  url              = each.value.url
  workspace_id     = tfe_workspace.workspace[each.key].id
}

# Triggers
resource "tfe_run_trigger" "trigger" {
  for_each = var.triggers

  workspace_id  = tfe_workspace.workspace[each.value].id
  sourceable_id = tfe_workspace.workspace[each.key].id
}
