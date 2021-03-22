provider "aws" {
  region = var.provider_region
}

# VPC module configuration
module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "2.77.0"

  name                          = var.vpc_name
  cidr                          = var.vpc_cidr

  azs                           = var.vpc_azs
  database_subnets              = var.vpc_database_subnets
  private_subnets               = var.vpc_private_subnets
  public_subnets                = var.vpc_public_subnets

  create_database_subnet_group  = true

  enable_nat_gateway            = var.vpc_enable_nat_gateway
  enable_dns_hostnames          = var.vpc_enable_dns_hostnames

  tags                          = var.vpc_tags
}

# Security group module configuration
module "security-group-db" {
  source                = "terraform-aws-modules/security-group/aws"
  version               = "3.18.0"

  name                  = var.sg_db_name
  vpc_id                = module.vpc.vpc_id

  ingress_cidr_blocks   = var.sg_db_ingress_cidr_blocks
  ingress_rules         = var.sg_db_ingress_rules
  egress_cidr_blocks    = var.sg_db_egress_cidr_blocks
  egress_rules          = var.sg_db_egress_rules
}
module "security-group-web" {
  source                = "terraform-aws-modules/security-group/aws"
  version               = "3.18.0"

  name                  = var.sg_web_name
  vpc_id                = module.vpc.vpc_id

  ingress_cidr_blocks   = var.sg_web_ingress_cidr_blocks
  ingress_rules         = var.sg_web_ingress_rules
  egress_cidr_blocks    = var.sg_web_egress_cidr_blocks
  egress_rules          = var.sg_web_egress_rules
}
module "rds" {
  source                                = "terraform-aws-modules/rds/aws"
  version                               = "2.30.0"

  engine                                = "mysql"
  engine_version                        = "5.7.19"
  family                                = "mysql5.7"
  major_engine_version                  = "5.7"
  instance_class                        = "db.t2.micro"
  
  allocated_storage                     = 5
  deletion_protection                   = false
  
  identifier                            = "terraformdb"

  name                                  = "terraformdb"
  username                              = "terraform"
  password                              = "terraform"
  port                                  = "3306"

  publicly_accessible                   = false
  multi_az                              = true
  subnet_ids                            = module.vpc.database_subnets
  vpc_security_group_ids                = [module.security-group-db.this_security_group_id]
  # iam_database_authentication_enabled   = true


  maintenance_window                    = "Mon:00:00-Mon:03:00"
  backup_window                         = "03:00-06:00"
  
  backup_retention_period               = 0
  skip_final_snapshot                   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

module "ec2-instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.17.0"

  name				                = var.ec2_name
  instance_count		          = var.ec2_instance_count
  associate_public_ip_address = var.ec2_associate_public_ip

  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  key_name 		                = var.ec2_ssh_key_name
  vpc_security_group_ids      = [module.security-group-web.this_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]

  tags                        = var.ec2_tags
  user_data                   = <<EOF
#!/bin/sh
sudo apt update
sudo apt upgrade -y
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y mysql-client
EOF
}


output "ec2_dns_hostnames" {
  value = module.ec2-instance.*.public_dns
}

output "rds_instance_endpoint" {
  value = module.rds.this_db_instance_endpoint
}
output "rds_instance_address" {
  value = module.rds.this_db_instance_address
}

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateDBInstance.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html#CHAP_Tutorials.WebServerDB.CreateVPC.VPCAndSubnets
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html#CHAP_Tutorials.WebServerDB.CreateVPC.AdditionalSubnets
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html#CHAP_Tutorials.WebServerDB.CreateVPC.SecurityGroupEC2
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html#CHAP_Tutorials.WebServerDB.CreateVPC.SecurityGroupDB
