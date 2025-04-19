variable "project_name" {}
variable "vpc_workload_a_id" {}
variable "vpc_workload_b_id" {}
variable "vpc_ingress_id" {}
variable "sub_priv_app_id_workload_a" {}
variable "sub_priv_app_id_workload_b" {}
variable "egress_route_depends_on" {}
variable "egress_propagation_depends_on" {}
variable "sub_priv_app_depends_on" {}
variable "pub_cidr_ingress" {
    type = list(string)
}
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = [ "099720109477" ]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }
}

