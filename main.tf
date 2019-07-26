provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../"

  name = "lab"


  cidr = "10.10.0.0/16"
    
   public_subnets      = "10.0.9.0/24" 
   private_subnets     = "10.0.4.0/22"
   data_subnets    = "10.0.0.0/22"
   platfomr_subnets  = "10.0.4.0/24"


  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = true


  # VPC endpoint for S3
  enable_s3_endpoint = true


  # VPC endpoint for SSM
  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]


  # VPC Endpoint for EC2
  enable_ec2_endpoint              = true
  ec2_endpoint_private_dns_enabled = true
  ec2_endpoint_security_group_ids  = [data.aws_security_group.default.id]


  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  tags = {
    Owner       = "ec2-user"
    Environment = "staging"
    Name        = "complete"
  }
}

