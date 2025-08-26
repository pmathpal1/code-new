variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet" {
  type = list(object(
    {
      name          = string
      address_space = string
    }
  ))
}

variable "subnet" {
  type = list(object(
    {
      subnet_name    = string
      address_prefix = string
      name           = string
    }
  ))
}
variable "storage_account_name" {
  type = string

}

variable "container_name" {
  type = string

}