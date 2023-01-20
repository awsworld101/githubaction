variable "rg" {
  description = "Default resource group name that the network will be created in."
  type        = list(any)
  default     = ["asd-rg", "asd2-rg"]

}

variable "location" {
  type        = list(any)
  description = "The location/region where the core network will be created."
  default     = ["westus", "eastus"]

}


