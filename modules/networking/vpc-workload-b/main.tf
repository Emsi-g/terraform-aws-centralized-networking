resource "aws_vpc" "vpc_workload_b" {
    provider = aws.account-b
    cidr_block = var.cidr_vpc_workload_b
    enable_dns_hostnames = true
    enable_dns_support = true  
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_b}-VPC"
    }
    
}

resource "aws_subnet" "priv_sub_app" {
    provider = aws.account-b
    count = length(var.priv_cidr_app_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    cidr_block = var.priv_cidr_app_workload_b[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-app-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_app_rtb" {
    provider = aws.account-b
    count = length(var.priv_cidr_app_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    route {
      cidr_block = "0.0.0.0/0"
      transit_gateway_id = var.tgw_id
    }
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-app-route-table-${count.index + 1}"
    }
    depends_on = [ var.tgwa_workload_b, var.tgwa_workload_b_accepter ]
}

resource "aws_route_table_association" "priv_sub_app_rtb_assoc" {
    provider = aws.account-b
    count = length(var.priv_cidr_app_workload_b)
    subnet_id = aws_subnet.priv_sub_app[count.index].id
    route_table_id = aws_route_table.priv_sub_app_rtb[count.index].id
}

resource "aws_subnet" "priv_sub_db" {
    provider = aws.account-b
    count = length(var.priv_cidr_db_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    cidr_block = var.priv_cidr_db_workload_b[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-db-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_db_rtb" {
    provider = aws.account-b
    count = length(var.priv_cidr_db_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    route {
      cidr_block = "0.0.0.0/0"
      transit_gateway_id = var.tgw_id
    }
    tags = {
       Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-db-route-table-${count.index + 1}"
    }
    depends_on = [ var.tgwa_workload_b, var.tgwa_workload_b_accepter ]
}

resource "aws_route_table_association" "priv_sub_db_rtb_assoc" {
    provider = aws.account-b
    count = length(var.priv_cidr_db_workload_b)
    subnet_id = aws_subnet.priv_sub_db[count.index].id
    route_table_id = aws_route_table.priv_sub_db_rtb[count.index].id
}

resource "aws_subnet" "priv_sub_tgw" {
    provider = aws.account-b
    count = length(var.priv_cidr_tgw_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    cidr_block = var.priv_cidr_tgw_workload_b[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-tgw-${count.index + 1}"
    }
    
}

resource "aws_route_table" "priv_sub_tgw_rtb" {
    provider = aws.account-b
    count = length(var.priv_cidr_tgw_workload_b)
    vpc_id = aws_vpc.vpc_workload_b.id
    tags = {
       Name = "${var.project_name}-${var.vpc_workload_b}-private-subnet-tgw-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "priv_sub_tgw_rtb_assoc" {
    provider = aws.account-b
    count = length(var.priv_cidr_tgw_workload_b)
    subnet_id = aws_subnet.priv_sub_tgw[count.index].id
    route_table_id = aws_route_table.priv_sub_tgw_rtb[count.index].id
}