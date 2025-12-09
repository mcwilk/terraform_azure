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