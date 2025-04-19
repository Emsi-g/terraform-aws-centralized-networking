variable "project_name" {}

#VPC Egress
variable "vpc_egress" {}
variable "cidr_vpc_egress" {}
variable "pub_cidr_egress" {
    type = list(string)
}
variable "priv_cidr_tgw_egress" {
    type = list(string)
}

#VPC Ingress
variable "vpc_ingress" {}
variable "cidr_vpc_ingress" {}
variable "pub_cidr_ingress" {
    type = list(string)
}
variable "priv_cidr_tgw_ingress" {
    type = list(string)
}

#VPC Workload A
variable "vpc_workload_a" {}
variable "cidr_vpc_workload_a" {}
variable "priv_cidr_app_workload_a" {
    type = list(string)
}
variable "priv_cidr_db_workload_a" {
    type = list(string)
}
variable "priv_cidr_tgw_workload_a" {
    type = list(string)
}

#VPC Workload B
variable "vpc_workload_b" {}
variable "cidr_vpc_workload_b" {}
variable "priv_cidr_app_workload_b" {
    type = list(string)
}
variable "priv_cidr_db_workload_b" {
    type = list(string)
}
variable "priv_cidr_tgw_workload_b" {
    type = list(string)
}

#NLB Private IP
variable "nlb_private_ip_a" {}
variable "nlb_private_ip_b" {}