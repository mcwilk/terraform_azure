variable "subscription_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
}

variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string
  default     = "HelloWorld_RG_TF"
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "westus"
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
    var.subnet_names[0] = ["10.0.1.0/24"],
    var.subnet_names[1] = ["10.0.2.0/24"]
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