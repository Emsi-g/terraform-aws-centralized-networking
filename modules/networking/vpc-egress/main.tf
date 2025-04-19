resource "aws_vpc" "vpc_egress" {
    cidr_block                  = var.cidr_vpc_egress
    enable_dns_hostnames        = true
    enable_dns_support          = true
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-VPC"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id                      = aws_vpc.vpc_egress.id
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-igw"
    }
}

resource "aws_eip" "EIP_NAT" {
    count = length(var.pub_cidr_egress)
    domain = "vpc"
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-EIP-NAT-${count.index + 1}"
    }
}

resource "aws_nat_gateway" "NAT_gateway" {
    count = length(var.pub_cidr_egress)
    allocation_id = aws_eip.EIP_NAT[count.index].id
    subnet_id = aws_subnet.pub_sub[count.index].id
    depends_on = [ aws_internet_gateway.igw ]
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-NAT-${count.index + 1}"
    }
}

resource "aws_subnet" "pub_sub" {
    count                       = length(var.pub_cidr_egress)
    vpc_id                      = aws_vpc.vpc_egress.id
    cidr_block                  = var.pub_cidr_egress[count.index]
    availability_zone           = local.azs[count.index]
    map_public_ip_on_launch     = true
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-public-subnet-${count.index + 1}"
    }
}

resource "aws_route_table" "pub_sub_rtb" {
    count = length(var.pub_cidr_egress)
    vpc_id = aws_vpc.vpc_egress.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    route {
      cidr_block = var.priv_cidr_app_workload_a[0]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_app_workload_a[1]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_db_workload_a[0]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_db_workload_a[1]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_app_workload_b[0]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_app_workload_b[1]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_db_workload_b[0]
      transit_gateway_id = var.tgw_id
    }
    route {
      cidr_block = var.priv_cidr_db_workload_b[1]
      transit_gateway_id = var.tgw_id
    }
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-public-subnet-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "pub_sub_rtb_assoc" {
    count = length(var.pub_cidr_egress)
    subnet_id = aws_subnet.pub_sub[count.index].id
    route_table_id = aws_route_table.pub_sub_rtb[count.index].id
}


resource "aws_subnet" "priv_sub_tgw" {
    count = length(var.priv_cidr_tgw_egress)
    vpc_id = aws_vpc.vpc_egress.id
    cidr_block = var.priv_cidr_tgw_egress[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-private-subnet-tgw-${count.index + 1}"
    }
}

resource "aws_route_table" "priv_sub_tgw_rtb" {
    count = length(var.priv_cidr_tgw_egress)
    vpc_id = aws_vpc.vpc_egress.id
    route {
        cidr_block = "0.0.0.0/0" 
        nat_gateway_id = aws_nat_gateway.NAT_gateway[count.index].id
    }
  
    tags = {
      Name = "${var.project_name}-${var.vpc_egress}-private-subnet-tgw-route-table-${count.index + 1}"
    }
}

resource "aws_route_table_association" "priv_sub_tgw_rtb_assoc" {
    count = length(var.priv_cidr_tgw_egress)
    subnet_id = aws_subnet.priv_sub_tgw[count.index].id
    route_table_id = aws_route_table.priv_sub_tgw_rtb[count.index].id
}

