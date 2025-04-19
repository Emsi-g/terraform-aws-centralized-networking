output "vpc_workload_a_id" {
  value = aws_vpc.vpc_workload_a.id
}

output "sub_priv_app_id_workload_a" {
  value = [for subnet in aws_subnet.priv_sub_app : subnet.id]
}

output "sub_tgw_workload_a_id" {
  value = [for subnet in aws_subnet.priv_sub_tgw : subnet.id]
}