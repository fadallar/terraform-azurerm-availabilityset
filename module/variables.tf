variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
  validation {
    condition     = var.stack == "" || can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.stack))
    error_message = "Invalid variable: ${var.stack}. Variable name must start with a lowercase letter, end with an alphanumeric lowercase character, and contain only lowercase letters, digits, or a dash (-)."
  }
}

variable "platform_update_domain_count" {
    description = " Specifies the number of update domains that are used.Changing this forces a new resource to be created."
    type = number
    default = 5
} 

variable "platform_fault_domain_count" {
    description = " Specifies the number of fault domains that are used.Changing this forces a new resource to be created"
    type = number
    default = 3
}

variable "proximity_placement_group_id" {
    description = "The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created."
    type = string
    default = null
}
#
variable "managed"  {
    description = " Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic).Changing this forces a new resource to be created."
    type = bool
    default = true
}