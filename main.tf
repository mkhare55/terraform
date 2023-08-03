module "compute-servers" {
  source                 = "./ec2-resources/compute_servers"
  image_id               = var.compute_image_id
  instance_type          = var.compute_instance_type
  vpc_security_group_ids = ["${module.aws_security_group.SecurityGroupDetails1}", "${module.aws_security_group.SecurityGroupDetails2}"]
  subnet_id              = module.vpc.private_subnets[0]
}

module "mid-tier-servers" {
  source                 = "./ec2-resources/mid-tier_servers"
  image_id               = var.mid-tier_image_id
  instance_type          = var.mid-tier_instance_type
  vpc_security_group_ids = ["${module.aws_security_group.SecurityGroupDetails1}", "${module.aws_security_group.SecurityGroupDetails2}"]
  subnet_id              = module.vpc.private_subnets[0]
}

module "web-servers" {
  source                 = "./networking/load_balancer/autoscaling"
  image_id               = var.web_image_id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = ["${module.aws_security_group.SecurityGroupDetails1}"]
  #subnet_id              = module.vpc.private_subnets[0]
  psubnet_id        = ["${module.vpc.private_subnets[0]}", "${module.vpc.private_subnets[1]}"]
  target_group_arns = ["${module.aws_lb.lb_tg_arn}"]

}

output "printf" {
  value = "echo 'kya hai mera security group' ${module.aws_security_group.SecurityGroupDetails2}"
  
}

module "aws_security_group" {
  source = "./networking/security_group"
  ports  = var.ports
  vpc_id = module.vpc.vpc_id
  security_groups = ["${module.aws_security_group.SecurityGroupDetails2}"]
}


module "vpc" {
  source = "./networking/vpc"

}


module "aws_lb" {
  source                 = "./networking/load_balancer"
  vpc_security_group_ids = ["${module.aws_security_group.SecurityGroupDetails2}"]
  psubnet_id             = ["${module.vpc.public_subnets[0]}", "${module.vpc.public_subnets[1]}"]
  vpc_id                 = module.vpc.vpc_id

}





