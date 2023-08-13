<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
# Azure Availability Set

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)

This module can be used to creates Azure Availability Set  

## Examples

[01\_base\_testcase](./examples/01\_base\_testcase/README.md)  
## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
   source  = "<module-path>"

   # Required variables
   landing_zone_slug =
   location =
   location_short =
   resource_group_name =
   stack =

   # Optional variables
   custom_name = ""
   default_tags = {}
   extra_tags = {}
   managed = true
   platform_fault_domain_count = 3
   platform_update_domain_count = 5
   proximity_placement_group_id = null
   workload_info = ""
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_landing_zone_slug"></a> [landing\_zone\_slug](#input\_landing\_zone\_slug) | Landing zone acronym,it will be used to generate the resource name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region to use. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short string for Azure location. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group. | `string` | n/a | yes |
| <a name="input_stack"></a> [stack](#input\_stack) | Project stack name. | `string` | n/a | yes |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom resource name, it will overide the generated name if set | `string` | `""` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Base tagging | `map(string)` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add. | `map(string)` | `{}` | no |
| <a name="input_managed"></a> [managed](#input\_managed) | Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic).Changing this forces a new resource to be created. | `bool` | `true` | no |
| <a name="input_platform_fault_domain_count"></a> [platform\_fault\_domain\_count](#input\_platform\_fault\_domain\_count) | Specifies the number of fault domains  that are used.Changing this forces a new resource to be created | `number` | `3` | no |
| <a name="input_platform_update_domain_count"></a> [platform\_update\_domain\_count](#input\_platform\_update\_domain\_count) | Specifies the number of update domains that are used. Changing this forces a new resource to be created. <br>  If the fault domain is set to 1 the update domain must be set to 1 | `number` | `5` | no |
| <a name="input_proximity_placement_group_id"></a> [proximity\_placement\_group\_id](#input\_proximity\_placement\_group\_id) | The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_workload_info"></a> [workload\_info](#input\_workload\_info) | Workload additional info to be used in the resource name | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Availability Set. |
## Contact

Atos

to regenerate this `README.md` file run in pwsh, in current directory:

`docker run --rm -v "$($pwd.path):/data" cytopia/terraform-docs terraform-docs-012 -c tfdocs-config.yml ./module`

`docker run --rm --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`

`docker stop pre; docker rm pre; docker run --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`  
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->