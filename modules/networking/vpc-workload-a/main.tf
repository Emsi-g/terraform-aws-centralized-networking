resource "aws_vpc" "vpc_workload_a" {
    cidr_block = var.cidr_vpc_workload_a
    enable_dns_hostnames = true
    enable_dns_support = true  
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_a}-VPC"
    }
}

resource "aws_subnet" "priv_sub_app" {
    count = length(var.priv_cidr_app_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    cidr_block = var.priv_cidr_app_workload_a[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-app-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_app_rtb" {
    count = length(var.priv_cidr_app_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    route {
      cidr_block = "0.0.0.0/0"
      transit_gateway_id = var.tgw_id
    }
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-app-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "priv_sub_app_rtb_assoc" {
    count = length(var.priv_cidr_app_workload_a)
    subnet_id = aws_subnet.priv_sub_app[count.index].id
    route_table_id = aws_route_table.priv_sub_app_rtb[count.index].id
}

resource "aws_subnet" "priv_sub_db" {
    count = length(var.priv_cidr_db_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    cidr_block = var.priv_cidr_db_workload_a[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-db-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_db_rtb" {
    count = length(var.priv_cidr_db_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    route {
      cidr_block = "0.0.0.0/0"
      transit_gateway_id = var.tgw_id
    }
    tags = {
       Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-db-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "priv_sub_db_rtb_assoc" {
    count = length(var.priv_cidr_db_workload_a)
    subnet_id = aws_subnet.priv_sub_db[count.index].id
    route_table_id = aws_route_table.priv_sub_db_rtb[count.index].id
}

resource "aws_subnet" "priv_sub_tgw" {
    count = length(var.priv_cidr_tgw_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    cidr_block = var.priv_cidr_tgw_workload_a[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-tgw-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_tgw_rtb" {
    count = length(var.priv_cidr_tgw_workload_a)
    vpc_id = aws_vpc.vpc_workload_a.id
    tags = {
       Name = "${var.project_name}-${var.vpc_workload_a}-private-subnet-tgw-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "priv_sub_tgw_rtb_assoc" {
    count = length(var.priv_cidr_tgw_workload_a)
    subnet_id = aws_subnet.priv_sub_tgw[count.index].id
    route_table_id = aws_route_table.priv_sub_tgw_rtb[count.index].id
}