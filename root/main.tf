module "vpc_egress" {
  source                        = "../modules/networking/vpc-egress"
  project_name                  = var.project_name
  vpc_egress                    = var.vpc_egress
  cidr_vpc_egress               = var.cidr_vpc_egress
  pub_cidr_egress               = var.pub_cidr_egress
  priv_cidr_tgw_egress          = var.priv_cidr_tgw_egress
  priv_cidr_app_workload_a      = var.priv_cidr_app_workload_a
  priv_cidr_db_workload_a       = var.priv_cidr_db_workload_a
  priv_cidr_app_workload_b      = var.priv_cidr_app_workload_b
  priv_cidr_db_workload_b       = var.priv_cidr_db_workload_b
  tgw_id                        = module.tgw.tgw_id
}

module "vpc_ingress" {
  source                        = "../modules/networking/vpc-ingress"
  project_name                  = var.project_name
  vpc_ingress                   = var.vpc_ingress
  cidr_vpc_ingress              = var.cidr_vpc_ingress
  pub_cidr_ingress              = var.pub_cidr_ingress
  priv_cidr_tgw_ingress         = var.priv_cidr_tgw_ingress
  priv_cidr_app_workload_a      = var.priv_cidr_app_workload_a
  priv_cidr_app_workload_b      = var.priv_cidr_app_workload_b
  tgw_id                        = module.tgw.tgw_id
}

module "vpc_workload_a" {
  source                        = "../modules/networking/vpc-workload-a"
  project_name                  = var.project_name
  vpc_workload_a                = var.vpc_workload_a
  cidr_vpc_workload_a           = var.cidr_vpc_workload_a
  priv_cidr_app_workload_a      = var.priv_cidr_app_workload_a
  priv_cidr_db_workload_a       = var.priv_cidr_db_workload_a
  priv_cidr_tgw_workload_a      = var.priv_cidr_tgw_workload_a
  tgw_id                        = module.tgw.tgw_id
}

module "vpc_workload_b" {
  source                        = "../modules/networking/vpc-workload-b"
  project_name                  = var.project_name
  vpc_workload_b                = var.vpc_workload_b
  cidr_vpc_workload_b           = var.cidr_vpc_workload_b
  priv_cidr_app_workload_b      = var.priv_cidr_app_workload_b
  priv_cidr_db_workload_b       = var.priv_cidr_db_workload_b
  priv_cidr_tgw_workload_b      = var.priv_cidr_tgw_workload_b
  tgw_id                        = module.tgw.tgw_id
  tgwa_workload_b_accepter      = module.tgw.tgwa_workload_b_accepter
  tgwa_workload_b               = module.tgw.tgwa_workload_b
  providers = {
    aws.account-b               = aws.account-b
  }
}

module "tgw" {
  source                        = "../modules/networking/tgw"
  project_name                  = var.project_name
  pub_cidr_ingress              = var.pub_cidr_ingress
  vpc_ingress_id                = module.vpc_ingress.vpc_ingress_id
  vpc_egress_id                 = module.vpc_egress.vpc_egress_id
  vpc_workload_a_id             = module.vpc_workload_a.vpc_workload_a_id
  vpc_workload_b_id             = module.vpc_workload_b.vpc_workload_b_id
  sub_tgw_ingress_id            = module.vpc_ingress.sub_tgw_ingress_id
  sub_tgw_egress_id             = module.vpc_egress.sub_tgw_egress_id
  sub_tgw_workload_a_id         = module.vpc_workload_a.sub_tgw_workload_a_id
  sub_tgw_workload_b_id         = module.vpc_workload_b.sub_tgw_workload_b_id
  providers = {
    aws.account-b               = aws.account-b
  }
}

module "ec2" {
  source                        = "../modules/resources/ec2"
  project_name                  = var.project_name
  pub_cidr_ingress              = var.pub_cidr_ingress
  vpc_ingress_id                = module.vpc_ingress.vpc_ingress_id
  vpc_workload_a_id             = module.vpc_workload_a.vpc_workload_a_id
  vpc_workload_b_id             = module.vpc_workload_b.vpc_workload_b_id
  sub_priv_app_id_workload_a    = module.vpc_workload_a.sub_priv_app_id_workload_a
  sub_priv_app_id_workload_b    = module.vpc_workload_b.sub_priv_app_id_workload_b
  sub_priv_app_depends_on       = module.vpc_workload_b.sub_priv_app_depends_on
  egress_propagation_depends_on = module.tgw.egress_propagation_depends_on
  egress_route_depends_on       = module.tgw.egress_route_depends_on
  providers = {
    aws.account-b               = aws.account-b
  }
}

module "alb" {
  source                        = "../modules/resources/alb"
  project_name                  = var.project_name
  nlb_private_ip_a              = var.nlb_private_ip_a
  nlb_private_ip_b              = var.nlb_private_ip_b
  vpc_ingress_id                = module.vpc_ingress.vpc_ingress_id
  sub_priv_app_id_workload_a    = module.vpc_workload_a.sub_priv_app_id_workload_a
  sub_pub_ingress_id            = module.vpc_ingress.sub_pub_ingress_id
  alb_workload_a_id_sg          = module.ec2.alb_workload_a_id_sg
  nlb_workload_a_id_sg          = module.ec2.nlb_workload_a_id_sg
  alb_workload_b_id_sg          = module.ec2.alb_workload_b_id_sg
  nlb_workload_a_tg_name        = module.ec2.nlb_workload_a_tg_name
  ec2_workload_b_private_ip     = module.ec2.ec2_workload_b_private_ip
  ec2_workload_b_depends_on     = module.ec2.ec2_workload_b_depends_on
  vpc_workload_a_id             = module.vpc_workload_a.vpc_workload_a_id
}