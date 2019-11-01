##################################################################################
# VARIABLES
##################################################################################

variable "username" {}
variable "password" {}
variable "endpoint" {}
variable "insecure" {}
variable "port" {}
variable "wait_timeout" {}
variable "vmname" {
  type = map(string)
}
variable "memory" {
  type = map(number)
}
variable "vmcount" {
  type = map(number)
}
variable "categories" {
  type = map(string)
}
variable "cluster_id" {
  type = map(string)
}

##################################################################################
# LOCALS
##################################################################################

locals {
  env_name = lower(terraform.workspace)
  common_tags = {
    Environment = local.env_name
  }
}
