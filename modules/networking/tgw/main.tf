#Create TGW
resource "aws_ec2_transit_gateway" "tgw" {
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    tags = {
      Name = "${var.project_name}-TGW"
    }
}

#Create TGW VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa_egress" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = var.vpc_egress_id
    subnet_ids = [ var.sub_tgw_egress_id[0],var.sub_tgw_egress_id[1] ]
    tags = {
      Name = "${var.project_name}-TGW-Attachment-VPC-Ingress"
    }  
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa_ingress" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = var.vpc_ingress_id
    subnet_ids = [ var.sub_tgw_ingress_id[0],var.sub_tgw_ingress_id[1] ]
    tags = {
      Name = "${var.project_name}-TGW-Attachment-VPC-Egress"
    } 
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa_workload_a" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = var.vpc_workload_a_id
    subnet_ids = [ var.sub_tgw_workload_a_id[0],var.sub_tgw_workload_a_id[1] ]
    tags = {
      Name = "${var.project_name}-TGW-Attachment-VPC-Workload-A"
    } 
}

# Create TGW Route table
resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_egress" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    tags = {
      Name = "${var.project_name}-TGW-RTB-Egress"
    }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_ingress" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    tags = {
      Name = "${var.project_name}-TGW-RTB-Ingress"
    }
}

resource "aws_ec2_transit_gateway_route_table" "tgw_rtb_workloads" {
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    tags = {
      Name = "${var.project_name}-TGW-RTB-Workloads"
    }
}

#TGW Association - Egress TGW Route Table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_egress_association" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_egress.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_egress.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rtb_egress_propagation_workload_a" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_a.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_egress.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rtb_egress_propagation_workload_b" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_b.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_egress.id
    depends_on = [ null_resource.wait_for_attachment ]
}

#TGW Association - Ingress TGW Route Table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_ingress_association" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_ingress.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_ingress.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rtb_ingress_propagation_workload_a" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_a.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_ingress.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_rtb_ingress_propagation_workload_b" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_b.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_ingress.id
    depends_on = [ null_resource.wait_for_attachment ]
}

#TGW Association - Workloads - A TGW Route Table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_workloads_A_association" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_a.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_workloads.id
}

#Create a route to NAT Gateway
resource "aws_ec2_transit_gateway_route" "tgw_rtb_workloads_to_egress" {
    destination_cidr_block = "0.0.0.0/0"
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_egress.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_workloads.id
}

#Create a route to ALB
resource "aws_ec2_transit_gateway_route" "tgw_rtb_workloads_to_ingress" {
    count = length(var.pub_cidr_ingress)
    destination_cidr_block = var.pub_cidr_ingress[count.index]
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_ingress.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_workloads.id
}

#Resource Access Manager - Share the TGW in other accounts
resource "aws_ram_resource_share" "ram" {
    name = "TGW Share"
    allow_external_principals = true
}

resource "aws_ram_resource_association" "ram_assoc" {
    resource_arn = aws_ec2_transit_gateway.tgw.arn
    resource_share_arn = aws_ram_resource_share.ram.arn
    depends_on = [ aws_ec2_transit_gateway.tgw ]
}

resource "aws_ram_principal_association" "ram_principal_assoc" {
    resource_share_arn = aws_ram_resource_share.ram.arn
    principal = local.account-b-AWS-ID
    depends_on = [ aws_ram_resource_association.ram_assoc ]
}

resource "aws_ram_resource_share_accepter" "ram_accepter" {
    provider = aws.account-b
    share_arn = aws_ram_resource_share.ram.arn
}

#### Account B - TGWA ####
resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa_workload_b" {
    provider = aws.account-b
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
    vpc_id = var.vpc_workload_b_id
    subnet_ids = [ var.sub_tgw_workload_b_id[0],var.sub_tgw_workload_b_id[1] ]
    tags = {
      Name = "${var.project_name}-TGW-Attachment-VPC-Workload-B"
    }
    depends_on = [ aws_ram_resource_share_accepter.ram_accepter ]
}

#Accept the TGW VPC attachment request
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "tgwa_workload_b_accept" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_b.id
    tags = {
      Name = "${var.project_name}-TGW-Attachment-VPC-Workload-B"
    }
}
resource "null_resource" "wait_for_attachment" {
    provisioner "local-exec" {
      command = "powershell -Command \"Start-Sleep -Seconds 120\""
    }
    triggers = {
      attachment_id = aws_ec2_transit_gateway_vpc_attachment_accepter.tgwa_workload_b_accept.id
    }
}

#TGW Association - Workloads-B TGW Route Table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rtb_workloads_B_association" {
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa_workload_b.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rtb_workloads.id
    depends_on = [ null_resource.wait_for_attachment ]
}