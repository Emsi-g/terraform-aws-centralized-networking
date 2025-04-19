variable "project_name" {}
variable "vpc_workload_a" {}
variable "cidr_vpc_workload_a" {}
variable "tgw_id" {}
variable "priv_cidr_app_workload_a" {
    type = list(string)
}
variable "priv_cidr_db_workload_a" {
    type = list(string)
}
variable "priv_cidr_tgw_workload_a" {
    type = list(string)
}
data "aws_availability_zones" "availability_zones" {}
locals {
  azs = data.aws_availability_zones.availability_zones.names
}