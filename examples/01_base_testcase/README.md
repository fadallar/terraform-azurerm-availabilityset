# Availability Set - Base Test Case

This is an example for setting-up a an Azure Availability Set.
This example

- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- A resource-group --> module "resource_group"
- Creates an availability set --> module "availabilit_set"

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->

<!-- END_AUTOMATED_TF_DOCS_BLOCK -->