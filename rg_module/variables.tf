variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string
  default     = "HelloWorld_RG_TF"
  validation {
    condition     = length(var.rg_name) > 10 && endswith(upper(var.rg_name), "RG_TF")
    error_message = "The resource group name must longer than 10 characters and end with RG_TF"
  }
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "westus"
  validation {
    condition     = contains(["eastus", "westus", "centralus"], lower(var.location))
    error_message = "Location must be one of: eastus, westus, centralus"
  }
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    environment = "DEV",
    project     = "TerraformDemo"
  }
}