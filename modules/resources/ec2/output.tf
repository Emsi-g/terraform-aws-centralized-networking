output "alb_workload_a_id_sg" {
  value = aws_security_group.alb_ingress_workload_a.id
}

output "nlb_workload_a_id_sg" {
  value = aws_security_group.nlb_ingress_workload_a.id
}

output "nlb_workload_a_tg_name" {
  value = aws_autoscaling_group.ec2_workload_asg.name
}

output "alb_workload_b_id_sg" {
  value = aws_security_group.alb_ingress_workload_b.id
}

output "ec2_workload_b_private_ip" {
  value = aws_instance.ec2_workload_b.private_ip
}

output "ec2_workload_b_depends_on" {
  value = aws_instance.ec2_workload_b
}