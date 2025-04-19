output "vpc_ingress_id" {
  value = aws_vpc.vpc_ingress.id
}

output "sub_pub_ingress_id" {
  value = [for subnet in aws_subnet.pub_sub : subnet.id]
}

output "sub_tgw_ingress_id" {
  value = [for subnet in aws_subnet.priv_sub_tgw : subnet.id]
}