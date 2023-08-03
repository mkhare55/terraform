module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  # variables
  name = "Dev-Asia"
  cidr = "10.10.96.0/20"

  //azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"
  //private_subnets       = ["10.10.96.0/24", "10.10.97.0/24", "10.10.98.0/24"]
  private_subnets = ["10.10.96.0/24","10.10.97.0/24"]
  //public_subnets        = ["10.10.100.0/24", "10.10.105.0/24", "10.10.110.0/24"]
  public_subnets = ["10.10.100.0/24", "10.10.105.0/24"]
  //private_subnet_names  = ["ZoneA-Private-Subnet", "ZoneB-Private-Subnet", "ZoneC-Private-Subnet"]
  private_subnet_names = ["ZoneA-Private-Subnet", "ZoneB-Private-Subnet"]

  //public_subnet_names   = ["ZoneA-Public-Subnet", "ZoneB-Public-Subnet", "ZoneC-Public-Subnet"]
  public_subnet_names = ["ZoneA-Public-Subnet", "ZoneB-Public-Subnet"]


  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}
output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}