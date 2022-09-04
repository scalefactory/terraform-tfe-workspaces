locals {
  # flatten() ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  # Generate workspace variables pairs to create resources, both (non-)sensistive
  work_vars = flatten([
    for work, path in var.workspaces : [
      for var_key, var in var.vars : {
        work    = work
        var_key = var_key
        path    = path
        var     = var
      }
    ]
  ])

  work_sec_vars = flatten([
    for work, path in var.workspaces : [
      for var_key, var in var.sec_vars : {
        work    = work
        var_key = var_key
        path    = path
        var     = var
      }
    ]
  ])
}

resource "tfe_variable" "vars" {
  # Project back into a map
  for_each = {
    for i in local.work_vars : "${i.work}.${i.var_key}" => i
  }

  category     = "env"
  key          = each.value.var_key
  value        = each.value.var
  workspace_id = tfe_workspace.workspace[each.value.work].id
  description  = "${each.value.var_key} for TerraformCloud"
  sensitive    = false

  lifecycle {
    create_before_destroy = false # To avoid having two variables with the same key
  }
}

resource "tfe_variable" "sec_vars" {
  # Project back into a map
  for_each = {
    for i in local.work_sec_vars : "${i.work}.${i.var_key}" => i
  }

  category     = "env"
  key          = each.value.var_key
  value        = each.value.var
  workspace_id = tfe_workspace.workspace[each.value.work].id
  description  = "${each.value.var_key} for TerraformCloud"
  sensitive    = true

  lifecycle {
    create_before_destroy = false # To avoid having two variables with the same key
  }
}
