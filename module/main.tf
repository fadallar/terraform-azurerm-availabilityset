# Add Checkov skips here, if required.
resource "azurerm_availability_set" "this" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.default_tags, var.extra_tags)

  platform_update_domain_count = var.platform_update_domain_count
  platform_fault_domain_count  = var.platform_fault_domain_count
  proximity_placement_group_id = var.proximity_placement_group_id
  managed                      = var.managed
}
