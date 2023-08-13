# Availability Set - Base Test Case

This is an example for setting-up a an Azure Availability Set.
This example

- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- A resource-group --> module "resource_group"
- Creates an availability set --> module "availabilit_set"

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Main.tf file content

Please replace the modules source and version with your relevant information

```hcl
# Test case local inputs
locals {
  stack             = "availset-01"
  landing_zone_slug = "sbx"
  location          = "westeurope"

  # 
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # base tagging values
  environment     = "sbx"
  application     = "terra-module"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A1"
  technical_owner = "Fabrice"

  # Availability Set

  platform_update_domain_count = 5
  platform_fault_domain_count  = 2 
  proximity_placement_group_id = null
  managed                      = true

}

module "regions" {
  source       = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module?ref=master"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  custom_name       = local.resource_group_name
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

resource "random_password" "vmpass" {
  length  = 20
  special = true
}

module "vm" {
  source                          = "git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-vmwindows//module?ref=release/1.1.0"
  landing_zone_slug               = local.landing_zone_slug
  stack                           = local.stack
  location                        = module.regions.location
  location_short                  = module.regions.location_short
  resource_group_name             = module.resource_group.resource_group_name
  default_tags                    = module.base_tagging.base_tags
  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  custom_name               = "vm-availability-set-1"
  hostname                  = "vm-availability-set-1"
  adminuser                 = "modulelocaladmin"
  admin_password            = random_password.vmpass
  subnet_id                 = module.subnet.subnet_id
  network_security_group_id = module.nsg.nsg_id

  enable_accelerated_networking = false
  enable_automatic_updates  = true
  enable_encryption_at_host = true

  custom_image        = local.vm_source_image_reference
  availability_set_id = azurerm_availability_set.this.id

  identity_type = "SystemAssigned"
  // OS Disk
  os_disk_caching              = local.vm_os_disk_caching
  os_disk_storage_account_type = local.vm_os_disk_storage_account_type
  os_disk_size_gb              = local.vm_os_disk_size_gb

}

# Please specify source as git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/<<ADD_MODULE_NAME>>//module?ref=master or with specific tag
module "availability_set" {
  source              = "../../module"
  custom_name         = local.custom_name
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  # Default Tags
  default_tags = module.base_tagging.base_tags
  # Extra Tags
  extra_tags = local.extra_tags
  
  # Module specific

  platform_update_domain_count = local.platform_update_domain_count
  platform_fault_domain_count  = local.platform_fault_domain_count
  proximity_placement_group_id = local.proximity_placement_group_id
  managed                      = local.managed

}
```
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_availability_set"></a> [availability\_set](#module\_availability\_set) | ../../module | n/a |
| <a name="module_base_tagging"></a> [base\_tagging](#module\_base\_tagging) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module | master |
| <a name="module_regions"></a> [regions](#module\_regions) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module | master |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module | master |
| <a name="module_vm"></a> [vm](#module\_vm) | git::https://ECTL-AZURE@dev.azure.com/ECTL-AZURE/ECTL-Terraform-Modules/_git/terraform-azurerm-vmwindows//module | release/1.1.0 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
## Resources

| Name | Type |
|------|------|
| [random_password.vmpass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
## Inputs

No inputs.
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_set_id"></a> [availability\_set\_id](#output\_availability\_set\_id) | Availability set Id |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
