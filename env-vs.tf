locals {
  # flatten() ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  # Generate variable sets and variables pair with arguments to create resources
  vs_vars = flatten([
    for name, obj in var.var_sets : [
      for k, o in obj.vars : {
        name      = name
        key       = k
        val       = o.val
        desc      = lookup(o, "desc", null)
        sensitive = lookup(o, "sensitive", false)
        category  = lookup(o, "category", "env")
      }
    ]
  ])

  vs_work = flatten([
    for name, obj in var.var_sets : [
      for w in contains(keys(obj), "workspaces") ? obj.workspaces : [] : { # Only if workspaces key is present
        name      = name
        workspace = w
      } if lookup(obj, "global", false) # Only if has key and not a global Variable set
    ]
  ])
}

resource "tfe_variable_set" "var_sets" {
  for_each = var.var_sets

  name         = each.key
  description  = lookup(each.value, "desc", null) # TODO: Handle in variable type contraints with TF v1.3
  global       = lookup(each.value, "global", false)
  organization = var.organization
}

resource "tfe_variable" "var_sets" {
  # Project back into a map
  for_each = {
    for i in local.vs_vars : "${i.name}.${i.key}" => i
  }

  category        = each.value.category
  key             = each.value.key
  value           = each.value.val
  variable_set_id = tfe_variable_set.var_sets[each.value.name].id
  description     = each.value.desc
  sensitive       = each.value.sensitive

  lifecycle {
    create_before_destroy = false # To avoid having two variables with the same key
  }
}

data "tfe_workspace_ids" "var_sets" {
  for_each = var.var_sets

  names        = lookup(each.value, "workspaces", []) # If unset use empty list
  organization = var.organization
}

resource "tfe_workspace_variable_set" "map" {
  # Project back into a map
  for_each = {
    for i in local.vs_work : "${i.name}.${i.workspace}" => i
  }

  workspace_id    = data.tfe_workspace_ids.var_sets[each.value.name].ids[each.value.workspace]
  variable_set_id = tfe_variable_set.var_sets[each.value.name].id
}
