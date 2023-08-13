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

module "session_host" {
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
