variable "project" {
  type = string
  default = "expense"

}

variable "environment" {
  type = string
  default = "dev"
}

variable "common_tags" {
  type = map
  default = {
    Name = "expense"
    environment = "dev"
    terraform = "true"
  }
}

variable "zone_name" {
  default = "vasanthreddy.space"
}