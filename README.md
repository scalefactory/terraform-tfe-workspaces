# TFE/C workspaces Terraform module

[![Terraform](https://github.com/scalefactory/terraform-tfe-workspaces/actions/workflows/terraform.yml/badge.svg)](https://github.com/scalefactory/terraform-tfe-workspaces/actions/workflows/terraform.yml)

Terraform workspaces module which manages configuration and life-cycle of all
your Terraform Cloud workspaces. It is designed to be used from a dedicated
Terraform Cloud workspace that would provision and manage rest of your
workspaces using Terraform code (IaC).

## Project status

`terraform-tfe-workspaces` is an open source project published by [The Scale Factory](https://www.scalefactory.com).

We currently consider this project to be actively maintained and we will add new
features, keep it security patched and ready for use in production environments.

We’ll take a look at any issues or PRs you open and get back to you as soon as
we can. We don’t offer any formal SLA, but we’ll be checking on this project
periodically.

## Features

- Create a Terraform Cloud/Enterprise workspace
- Set configuration settings:
  - VCS
  - Variables
  - Alerts
  - Triggers
- Remove workspaces

## Usage example

Workspaces configured by this module will likely require credentials for
authenticating to the various services you wish to use.

For example, if we're configuring a workspace that requires AWS credentials, you
will configure using the following code:

_main.tf_:
```hcl
terraform {
  required_version = ">= 0.13.6, < 2.0"

  backend "remote" {
    organization = "scalefactory"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

module "workspaces" {
  source = "../modules/terraform-tfe-workspaces"

  organization   = "scalefactory"
  oauth_token_id = var.oauth_token_id
  vcs_org        = "scalefactory"
  vcs_repo       = "terraform-infra"
  #tf_version     = "1.x.y"
  workspaces         = var.workspaces
  slacks             = var.slacks
  triggers           = var.triggers
  TFC_WORKSPACE_NAME = var.TFC_WORKSPACE_NAME

  var_sets = var.var_sets

  vars = {
    AWS_ACCESS_KEY_ID = var.aws_access_key_id
  }

  sec_vars = {
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }
}
```

_terraform.auto.tfvars_:
```terraform
workspaces = {
  shared       = "terraform/shared"
}

var_sets = {
    test = {
        desc   = "Testing"
        global = false
        vars = {
            a = {
                val       = 1
                sensitive = false
                desc      = "woohoo"
                category  = "env"
            }
            b = {
                val       = 2
                sensitive = true
            }
        }
        workspaces = [
          "workspace1",
          "workspace2",
        ]
    }
}
```

<!-- TODO
There is also a more complete [example](example/) which shows more features available.
-->
## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/scalefactory/terraform-tfe-workspaces/issues/new) section.

Full contributing [guidelines are covered here](CONTRIBUTING.md).

## Authors

* [Marko Bevc](https://github.com/mbevc1)
* [David O'Rourke](https://github.com/phyber)
* Full [contributors list](https://github.com/scalefactory/terraform-tfe-workspaces/graphs/contributors)

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.6, < 2.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | ~> 0.38.0 |

## Resources

| Name | Type |
|------|------|
| [tfe_notification_configuration.slack](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration) | resource |
| [tfe_run_trigger.trigger](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/run_trigger) | resource |
| [tfe_variable.sec_vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.var_sets](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vars](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.var_sets](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace.workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |
| [tfe_workspace_variable_set.map](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_variable_set) | resource |
| [tfe_workspace.current](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |
| [tfe_workspace_ids.var_sets](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace_ids) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_TFC_WORKSPACE_NAME"></a> [TFC\_WORKSPACE\_NAME](#input\_TFC\_WORKSPACE\_NAME) | TFC workspace name from the ENV | `string` | `null` | no |
| <a name="input_assessments_enabled"></a> [assessments\_enabled](#input\_assessments\_enabled) | Regularly run health assessments such as drift detection on the workspace | `bool` | `false` | no |
| <a name="input_execution_mode"></a> [execution\_mode](#input\_execution\_mode) | Terraform worskapce execution more: remote, local or agent | `string` | `"remote"` | no |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | ID of the oAuth token for the VCS connection | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | TF Organization to create workspaces under | `string` | n/a | yes |
| <a name="input_sec_vars"></a> [sec\_vars](#input\_sec\_vars) | Map defining workspace sensitive variables | `map(any)` | `{}` | no |
| <a name="input_slacks"></a> [slacks](#input\_slacks) | Map definning Slack notification options | `map(any)` | `{}` | no |
| <a name="input_speculative_enabled"></a> [speculative\_enabled](#input\_speculative\_enabled) | Weather running plans on pull requests | `bool` | `true` | no |
| <a name="input_structured_run_output_enabled"></a> [structured\_run\_output\_enabled](#input\_structured\_run\_output\_enabled) | Whether this workspace should show output from Terraform runs using the enhanced UI when available | `bool` | `false` | no |
| <a name="input_tag_names"></a> [tag\_names](#input\_tag\_names) | List of workspace tag names | `list(any)` | `[]` | no |
| <a name="input_tf_version"></a> [tf\_version](#input\_tf\_version) | Version of Terraform to use in workspace | `string` | `null` | no |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | Map for TFE trigger relations workspace->workspace2 | `map(any)` | `{}` | no |
| <a name="input_var_sets"></a> [var\_sets](#input\_var\_sets) | Map defining variable sets | `any` | `{}` | no |
| <a name="input_vars"></a> [vars](#input\_vars) | Map defining workspace variables | `map(any)` | `{}` | no |
| <a name="input_vcs_org"></a> [vcs\_org](#input\_vcs\_org) | The Github organization that repositories live under | `string` | n/a | yes |
| <a name="input_vcs_repo"></a> [vcs\_repo](#input\_vcs\_repo) | The Github repository name that is backing this workspace | `string` | n/a | yes |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | Workspaces map where we define workspace and its path | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_work_vars"></a> [work\_vars](#output\_work\_vars) | n/a |
<!-- END_TF_DOCS -->
