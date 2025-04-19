#Create ALB Workload-A
resource "aws_lb" "alb_workload_a" {
    name = "${var.project_name}-alb-workload-a"
    load_balancer_type = "application"
    security_groups = [ var.alb_workload_a_id_sg ]
    subnets = [ var.sub_pub_ingress_id[0], var.sub_pub_ingress_id[1] ]
    internal = false
    enable_deletion_protection = false
    tags = {
        Name = "${var.project_name}-alb-workload-a"
    }
    depends_on = [ aws_lb.nlb_workload_a ]
}

resource "aws_lb_target_group" "alb_workload_a_tg" {
    name = "${var.project_name}-alb-workload-a-tg"
    vpc_id = var.vpc_ingress_id
    target_type = "ip"
    port = 80
    protocol = "HTTP"
    lifecycle {
        create_before_destroy       = true
    }
    tags = {
      Name = "${var.project_name}-ALB-Workload-A-TG" 
    }
}

resource "aws_lb_target_group_attachment" "alb_workload_a_tg_attachment_a" {
    target_group_arn = aws_lb_target_group.alb_workload_a_tg.arn
    target_id = var.nlb_private_ip_a
    availability_zone = "all"
    port = 80
}

resource "aws_lb_target_group_attachment" "alb_workload_a_tg_attachment_b" {
    target_group_arn = aws_lb_target_group.alb_workload_a_tg.arn
    target_id = var.nlb_private_ip_b
    availability_zone = "all"
    port = 80
}

resource "aws_lb_listener" "alb_workload_a_listener" {
    load_balancer_arn = aws_lb.alb_workload_a.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_workload_a_tg.arn
    }
    depends_on = [ aws_lb_target_group.alb_workload_a_tg ]
}


#Create NLB Workload-A
resource "aws_lb" "nlb_workload_a" {
    name = "${var.project_name}-nlb-workload-a"
    load_balancer_type = "network"
    security_groups = [ var.nlb_workload_a_id_sg ]
    internal = true
    enable_deletion_protection = false
    enable_cross_zone_load_balancing = false
    subnet_mapping {
      subnet_id = var.sub_priv_app_id_workload_a[0]
      private_ipv4_address = var.nlb_private_ip_a
    }
    subnet_mapping {
      subnet_id = var.sub_priv_app_id_workload_a[1]
      private_ipv4_address = var.nlb_private_ip_b
    }
    tags = {
        Name = "${var.project_name}-nlb-workload-a"
    }
}

resource "aws_lb_target_group" "nlb_workload_a_tg" {
    name = "${var.project_name}-nlb-workload-a-tg"
    vpc_id = var.vpc_workload_a_id
    target_type = "instance"
    preserve_client_ip = false
    port = 80
    protocol = "TCP"
    health_check {
      protocol            = "HTTP"
      port                = "traffic-port"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      interval            = 30
      timeout             = 10
    }
    lifecycle {
      create_before_destroy = true
    }
    tags = {
      Name = "${var.project_name}-NLB-Workload-A-TG" 
    }
    depends_on = [ aws_lb.nlb_workload_a ]
}

resource "aws_lb_listener" "nlb_workload_a_tg_listener" {
    load_balancer_arn = aws_lb.nlb_workload_a.arn
    port = 80
    protocol = "TCP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.nlb_workload_a_tg.arn
    }
    depends_on = [ aws_lb_target_group.nlb_workload_a_tg ]
}

resource "aws_autoscaling_attachment" "asg_nlb_attachment" {
    autoscaling_group_name = var.nlb_workload_a_tg_name
    lb_target_group_arn = aws_lb_target_group.nlb_workload_a_tg.arn
    depends_on = [ aws_lb_target_group.nlb_workload_a_tg ]
}

#Create ALB for Workload-B
resource "aws_lb" "alb_workload_b" {
    name = "${var.project_name}-alb-workload-b"
    load_balancer_type = "application"
    security_groups = [ var.alb_workload_b_id_sg ]
    subnets = [ var.sub_pub_ingress_id[0], var.sub_pub_ingress_id[1] ]
    internal = false
    enable_deletion_protection = false
    tags = {
        Name = "${var.project_name}-alb-workload-b"
    }
    depends_on = [ var.ec2_workload_b_depends_on ]
}

resource "aws_lb_target_group" "alb_workload_b_tg" {
    name = "${var.project_name}-alb-workload-b-tg"
    vpc_id = var.vpc_ingress_id
    target_type = "ip"
    port = 80
    protocol = "HTTP"
    lifecycle {
        create_before_destroy       = true
    }
    tags = {
      Name = "${var.project_name}-ALB-Workload-B-TG" 
    }
}

resource "aws_lb_target_group_attachment" "alb_workload_b_tg_attachment" {
    target_group_arn = aws_lb_target_group.alb_workload_b_tg.arn
    target_id = var.ec2_workload_b_private_ip
    availability_zone = "all"
    port = 80
    depends_on = [ var.ec2_workload_b_depends_on ]
}

resource "aws_lb_listener" "alb_workload_b_listener" {
    load_balancer_arn = aws_lb.alb_workload_b.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_workload_b_tg.arn
    }
    depends_on = [ aws_lb_target_group.alb_workload_b_tg ]
}