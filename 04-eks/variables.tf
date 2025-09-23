variable "project" {
  type = string
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tag" {
  type = map
  default = {
    Name = "expense"
    environment = "dev"
  }
}