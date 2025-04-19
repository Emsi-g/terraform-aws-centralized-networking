output "vpc_workload_b_id" {
  value = aws_vpc.vpc_workload_b.id
}

output "sub_priv_app_id_workload_b" {
  value = [for subnet in aws_subnet.priv_sub_app : subnet.id]
}

output "sub_tgw_workload_b_id" {
  value = [for subnet in aws_subnet.priv_sub_tgw : subnet.id]
}

output "sub_priv_app_depends_on" {
  value = aws_subnet.priv_sub_app
}