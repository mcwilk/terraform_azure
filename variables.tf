variable "subscription_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
}

variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string
  default     = "HelloWorld_RG_TFabc"
  validation {
    condition     = length(var.rg_name) > 10 && endswith(upper(var.rg_name), "RG_TF")
    error_message = "The resource group name must longer than 10 characters and end with RG_TF"
  }
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "westus"
  validation  {
    condition     = contains(["eastus", "westus", "centralus"], lower(var.location))
    error_message = "Location must be one of: eastus, westus, centralus"
  }
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
  default     = "dev01vm-TF"
}

variable "enable_password_authentication" {
  description = "Is password authentication enabled?"
  type        = bool
  default     = false
}

variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
  default     = ["dev_subnet_TF", "test_subnet_TF"]
}

variable "subnet_addresses" {
  description = "Dict of subnet addresses"
  type        = map(list(string))
  default     = {
    "dev_subnet_TF" = ["10.0.1.0/24"],
    "test_subnet_TF" = ["10.0.2.0/24"]
  }
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    environment = "DEV",
    project     = "TerraformDemo"
  }
}

variable "subnets" {
  description = "Subnets information"
  type        = map(any)
  default     = {
    uat_subnet_TF = {
      address = ["10.0.3.0/24"]
    },
    prod_subnet_TF = {
      address = ["10.0.4.0/24"]
    }
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "tfdemo"
}

variable "env" {
  description = "Environment"
  type = string
  default = "dev"
}