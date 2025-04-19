variable "project_name" {}
variable "vpc_egress" {}
variable "cidr_vpc_egress" {}
variable "tgw_id" {}
variable "pub_cidr_egress" {
    type = list(string)
}
variable "priv_cidr_tgw_egress" {
    type = list(string)
}
variable "priv_cidr_app_workload_a" {
    type = list(string)
}
variable "priv_cidr_db_workload_a" {
    type = list(string)
}
variable "priv_cidr_app_workload_b" {
    type = list(string)
}
variable "priv_cidr_db_workload_b" {
    type = list(string)
}
data "aws_availability_zones" "availability_zone" {}
locals {
  azs = data.aws_availability_zones.availability_zone.names
}