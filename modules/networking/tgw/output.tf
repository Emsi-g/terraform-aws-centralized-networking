output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "tgwa_workload_b" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_b
}

output "tgwa_workload_b_accepter" {
  value = aws_ec2_transit_gateway_vpc_attachment_accepter.tgwa_workload_b_accept
}

output "egress_route_depends_on" {
  value = aws_ec2_transit_gateway_route.tgw_rtb_workloads_to_egress
}

output "egress_propagation_depends_on" {
  value = aws_ec2_transit_gateway_route_table_propagation.tgw_rtb_ingress_propagation_workload_a
}