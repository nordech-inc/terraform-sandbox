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

  create_database_subnet_group  = var.vpc_create_db_subnet_grp

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
  
  identifier                            = var.rds_identifier

  engine                                = var.rds_engine
  engine_version                        = var.rds_engine_version
  family                                = var.rds_family
  major_engine_version                  = var.rds_major_engine_version
  instance_class                        = var.rds_instance_class
  
  allocated_storage                     = var.rds_allocated_storage
  
  name                                  = var.rds_db_name
  username                              = var.rds_db_username
  password                              = var.rds_db_password
  port                                  = var.rds_db_port

  publicly_accessible                   = false
  multi_az                              = var.rds_multi_az
  subnet_ids                            = module.vpc.database_subnets
  vpc_security_group_ids                = [module.security-group-db.this_security_group_id]

  maintenance_window                    = var.rds_maintenance_window
  backup_window                         = var.rds_backup_window
  
  backup_retention_period               = 0
  skip_final_snapshot                   = var.rds_skip_final_snapshot
  deletion_protection                   = false

  tags                                  = var.rds_tags

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
