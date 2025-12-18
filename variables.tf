variable "subscription_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "firewall_rules" {
  description = "Firewall exceptions to connect to VM"
  type        = map(any)
  default = {
    SSH = {
      name                   = "SSH"
      priority               = "300"
      destination_port_range = 22
    },
    HTTPS = {
      name                   = "HTTPS"
      priority               = "400"
      destination_port_range = 443
    }
  }
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
  default     = "vm-TF"
}

variable "number_of_vm" {
  description = "Number of VM instances to create"
  type        = number
  default     = 2
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
  default = {
    "dev_subnet_TF"  = ["10.0.1.0/24"],
    "test_subnet_TF" = ["10.0.2.0/24"]
  }
}

variable "subnets" {
  description = "Subnets information"
  type        = map(any)
  default = {
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
  type        = string
  default     = "dev"
}

variable "sa_prefix" {
  description = "Prefix (base name) for Storage Account"
  type        = string
  default     = "sahome"
}