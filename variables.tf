variable "do_token" {
  description = "DigitalOcean API token "
  type = string
  sensitive = true
  default = ""
}

variable "subnet" {
  description = "Subnet for the droplet"
  type        = string
  default     = "10.11.13.0/24"
}

variable "name" {
  description = "Name"
  type        = string
  default     = "piotr-najdychor-resources-terraform"
}

variable "region" {
  description = "Name of region"
  type = string
  default = "fra1"
}