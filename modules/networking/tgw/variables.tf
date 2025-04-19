variable "project_name" {}
variable "vpc_ingress_id" {}
variable "vpc_egress_id" {}
variable "vpc_workload_a_id" {}
variable "vpc_workload_b_id" {}
variable "sub_tgw_ingress_id" {}
variable "sub_tgw_egress_id" {}
variable "sub_tgw_workload_a_id" {}
variable "sub_tgw_workload_b_id" {}
variable "pub_cidr_ingress" {
    type = list(string)
}
data "aws_caller_identity" "account-b" {
  provider = aws.account-b
}
locals {
  account-b-AWS-ID = data.aws_caller_identity.account-b.account_id
}
