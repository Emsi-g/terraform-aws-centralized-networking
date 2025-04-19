project_name = "TGW"

#VPC Egress
vpc_egress = "egress"
cidr_vpc_egress = "10.1.0.0/16"
pub_cidr_egress = [ "10.1.10.0/24", "10.1.11.0/24" ]
priv_cidr_tgw_egress = [ "10.1.110.0/28", "10.1.111.0/28" ]

#VPC Ingress
vpc_ingress = "ingress"
cidr_vpc_ingress = "10.2.0.0/16"
pub_cidr_ingress = [ "10.2.10.0/24", "10.2.11.0/24" ]
priv_cidr_tgw_ingress = [ "10.2.110.0/28", "10.2.111.0/28" ]

#VPC Workload A
vpc_workload_a = "workload-A"
cidr_vpc_workload_a = "10.3.0.0/16"
priv_cidr_app_workload_a = [ "10.3.10.0/24", "10.3.11.0/24" ]
priv_cidr_db_workload_a = [ "10.3.20.0/24", "10.3.21.0/24" ]
priv_cidr_tgw_workload_a = [ "10.3.110.0/28", "10.3.111.0/28" ]

#VPC Workload B
vpc_workload_b = "workload-B"
cidr_vpc_workload_b = "10.4.0.0/16"
priv_cidr_app_workload_b = [ "10.4.10.0/24", "10.4.11.0/24" ]
priv_cidr_db_workload_b = [ "10.4.20.0/24", "10.4.21.0/24" ]
priv_cidr_tgw_workload_b = [ "10.4.110.0/28", "10.4.111.0/28" ]

#NLB Private IP
nlb_private_ip_a = "10.3.10.10" 
nlb_private_ip_b = "10.3.11.11"
