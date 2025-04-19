variable "project_name" {}
variable "vpc_workload_b" {}
variable "cidr_vpc_workload_b" {}
variable "tgw_id" {}
variable "tgwa_workload_b" {}
variable "tgwa_workload_b_accepter" {}
variable "priv_cidr_app_workload_b" {
    type = list(string)
}
variable "priv_cidr_db_workload_b" {
    type = list(string)
}
variable "priv_cidr_tgw_workload_b" {
    type = list(string)
}
data "aws_availability_zones" "availability_zone" {}
locals {
  azs = data.aws_availability_zones.availability_zone.names
}