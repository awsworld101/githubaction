variable "rg" {
  type = map(any)
  default = {
    "rg1" = { location = "westus 2" }
    "rg2" = { location = "westus" }
    "rg3" = { location = "eastus 2" }
    "rg4" = { location = "eastus" }
  }

}

variable "tagname" {
  type = map(any)
  default = {
    name   = "prod"
    tier   = "mgt"
    client = "tcs"
  }

}
