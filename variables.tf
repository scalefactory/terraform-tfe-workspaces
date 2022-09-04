#// Should be provided from the Terraform Cloud environment
#variable aws_access_key_id {
#  description = "The AWS_ACCESS_KEY_ID for TerraformCloud runs"
#  type        = string
#}
#
#// Should be provided from the Terraform Cloud environment
#variable aws_secret_access_key {
#  description = "The AWS_SECRET_ACCESS_KEY for TerraformCloud runs"
#  type        = string
#}

variable "oauth_token_id" {
  description = "ID of the oAuth token for the VCS connection"
  type        = string
}

variable "organization" {
  description = "TF Organization to create workspaces under"
  type        = string
}

variable "tf_version" {
  description = "Version of Terraform to use in workspace"
  type        = string
  default     = null
}

variable "vcs_org" {
  description = "The Github organization that repositories live under"
  type        = string
}

variable "vcs_repo" {
  description = "The Github repository name that is backing this workspace"
  type        = string
}

variable "workspaces" {
  description = "Workspaces map where we define workspace and its path"
  type        = map(any)
  default     = {}
}

variable "slacks" {
  description = "Map definning Slack notification options"
  type        = map(any)
  default     = {}
}

variable "triggers" {
  description = "Map for TFE trigger relations workspace->workspace2"
  type        = map(any)
  default     = {}
}

variable "execution_mode" {
  description = "Terraform worskapce execution more: remote, local or agent"
  type        = string
  default     = "remote"
}

variable "tag_names" {
  description = "List of workspace tag names"
  type        = list(any)
  default     = []
}

variable "vars" {
  description = "Map defining workspace variables"
  type        = map(any)
  default     = {}
}

variable "sec_vars" {
  description = "Map defining workspace sensitive variables"
  type        = map(any)
  default     = {}
}

variable "var_sets" {
  description = "Map defining variable sets"
  type = any
  #map(object({
    # TODO: refactor using optional values when TF v1.3 is released
    #desc       = optional(string)
    #global     = optional(bool, false)
    #vars       = map(any)
    #workspaces = optional(list(string))
  #}))
  default = {}
}

variable "TFC_WORKSPACE_NAME" {
  description = "TFC workspace name from the ENV"
  type        = string
  default     = null
}
