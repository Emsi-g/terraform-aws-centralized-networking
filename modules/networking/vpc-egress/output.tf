output "vpc_egress_id" {
  value = aws_vpc.vpc_egress.id
}

output "sub_tgw_egress_id" {
  value = [for subnet in aws_subnet.priv_sub_tgw : subnet.id]
}