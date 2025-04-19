#Create EC2 workload - A
resource "aws_launch_template" "ec2_workload_a_launch_template" {
    name =  "${var.project_name}-EC2-Workload-A"
    instance_type = "t3.small"
    image_id = data.aws_ami.ubuntu_ami.id
    user_data = filebase64("../modules/resources/ec2/init.sh")
    block_device_mappings {
      device_name = "/dev/xvda"
      ebs {
        encrypted = true
        volume_size = 10
        volume_type = "gp3"
      }
    }
    iam_instance_profile {
      name = "AmazonSSMRoleForInstancesQuickSetup"
    }
    network_interfaces {
      associate_public_ip_address = false
      security_groups = [ aws_security_group.ec2_workload_a.id  ]
    }
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "${var.project_name}-EC2-Workload-A"
      }
    }
    depends_on = [ var.egress_propagation_depends_on, var.egress_route_depends_on ]
}

#Create ASG for Workload A
resource "aws_autoscaling_group" "ec2_workload_asg" {
    name = "${var.project_name}-EC2-Workload-A-ASG"
    vpc_zone_identifier = [ var.sub_priv_app_id_workload_a[0],var.sub_priv_app_id_workload_a[1] ]
    desired_capacity = 2
    max_size = 3
    min_size = 1
    health_check_type = "ELB"
    health_check_grace_period = 300
    launch_template {
      id = aws_launch_template.ec2_workload_a_launch_template.id
      version = aws_launch_template.ec2_workload_a_launch_template.latest_version
    }
    lifecycle {
      create_before_destroy = true
    }
    tag {
      key = "Name"
      value = "${var.project_name}-EC2-Workload-A-ASG"
      propagate_at_launch = true
    }
}


#Create EC2 workload - B
resource "aws_instance" "ec2_workload_b" {
    provider = aws.account-b
    instance_type = "t3.small"
    ami = data.aws_ami.ubuntu_ami.id
    subnet_id = var.sub_priv_app_id_workload_b[0]
    vpc_security_group_ids = [ aws_security_group.ec2_workload_b.id ]
    associate_public_ip_address = false
    iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
    user_data = filebase64("../modules/resources/ec2/init.sh")
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }
    tags = {
      Name = "${var.project_name}-EC2-Workload-B"
    }
    depends_on = [ var.sub_priv_app_depends_on ]
}

#Security Groups
resource "aws_security_group" "alb_ingress_workload_a" {
    vpc_id = var.vpc_ingress_id
    name = "${var.project_name}-ALB-Workload-A-SG"
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        to_port = 0
        from_port = 0
    }
    tags = {
      Name = "${var.project_name}-ALB-Workload-A-SG"
    }
}

resource "aws_security_group" "nlb_ingress_workload_a" {
    vpc_id = var.vpc_workload_a_id
    name = "${var.project_name}-NLB-Workload-A-SGs"
    ingress {
        cidr_blocks = [ var.pub_cidr_ingress[0] ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    ingress {
        cidr_blocks = [ var.pub_cidr_ingress[1] ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        to_port = 0
        from_port = 0
    }
    tags = {
      Name = "${var.project_name}-ALB-Workload-A-SG"
    }
}

resource "aws_security_group" "alb_ingress_workload_b" {
    vpc_id = var.vpc_ingress_id
    name = "${var.project_name}-ALB-Workload-B-SG"
    ingress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        to_port = 0
        from_port = 0
    }
    tags = {
      Name = "${var.project_name}-ALB-Workload-B-SG"
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "ec2_workload_a" {
    vpc_id = var.vpc_workload_a_id
    name = "${var.project_name}-EC2-Workload-A-SG"
    ingress {
        security_groups = [ aws_security_group.nlb_ingress_workload_a.id ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    ingress {
        security_groups = [ aws_security_group.nlb_ingress_workload_a.id ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        to_port = 0
        from_port = 0
    }
    tags = {
      Name = "${var.project_name}-EC2-Workload-A-SG"
    }
}

resource "aws_security_group" "ec2_workload_b" {
    provider = aws.account-b
    vpc_id = var.vpc_workload_b_id
    name = "${var.project_name}-EC2-Workload-B-SG"
    ingress {
        cidr_blocks = [ var.pub_cidr_ingress[0] ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    ingress {
        cidr_blocks = [ var.pub_cidr_ingress[1] ]
        protocol = "TCP"
        to_port = 80
        from_port = 80
    }
    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "-1"
        to_port = 0
        from_port = 0
    }
    tags = {
      Name = "${var.project_name}-EC2-Workload-B-SG"
    }
}