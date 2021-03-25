# provider settings
variable "provider_region" {
  description = "region for provider"
  type = string
  default = "us-east-1"
}

# VPC variables
variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "terraform-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "vpc_database_subnets" {
  description = "Database subnets for VPC"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}
variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.20.4.0/24", "10.20.5.0/24", "10.20.6.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.20.7.0/24", "10.20.8.0/24", "10.20.9.0/24"]
}

variable "vpc_create_db_subnet_grp" {
  description = "Database subnet group for VPC"
  type        = bool
  default     = true
}
variable "vpc_enable_nat_gateway" {
  description = "NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "DNS hostnames for VPC"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description   = "Tags to apply to VPC"
  type          = map(string)
  default       = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Security group variables
variable "sg_web_name" {
  description = "name for security group"
  type        = string
  default     = "terraform-web-sg"
}

variable "sg_web_ingress_cidr_blocks" {
  description = "ingress CIDR block for security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "sg_web_ingress_rules" {
  description = "ingress rules for security group"
  type        = list(string)
  default     = ["ssh-tcp", "http-80-tcp", "https-443-tcp", "mysql-tcp"]
}

variable "sg_web_egress_cidr_blocks" {
  description = "egress CIDR block for security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "sg_web_egress_rules" {
  description = "egress rules for security group"
  type        = list(string)
  default     = ["all-all"]
}

variable "sg_db_name" {
  description = "name for security group"
  type        = string
  default     = "terraform-db-sg"
}

variable "sg_db_ingress_cidr_blocks" {
  description = "ingress CIDR block for security group"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "sg_db_ingress_rules" {
  description = "ingress rules for security group"
  type        = list(string)
  default     = ["mysql-tcp"]
}

variable "sg_db_egress_cidr_blocks" {
  description = "egress CIDR block for security group"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "sg_db_egress_rules" {
  description = "egress rules for security group"
  type        = list(string)
  default     = ["all-all"]
}

variable "rds_identifier" {
  description = "Identifier for RDS"
  type        = string
  default     = "terraform-db-cluster"
}
variable "rds_engine" {
  description = "Engine for RDS"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Engine version for RDS"
  type        = string
  default     = "8.0.20"
}
variable "rds_family" {
  description = "Family for RDS"
  type        = string
  default     = "mysql8.0"
}
variable "rds_major_engine_version" {
  description = "Major engine version for RDS"
  type        = string
  default     = "8.0"
}
variable "rds_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}
variable "rds_allocated_storage" {
  description = "Allocated storage size for RDS"
  type        = number
  default     = 5
}

variable "rds_db_name" {
  description = "DB name for RDS"
  type        = string
  default     = "terraformdb"
}
variable "rds_db_username" {
  description = "DB username for RDS"
  type        = string
  default     = "terraform"
}
variable "rds_db_password" {
  description = "DB password for RDS"
  type        = string
  default     = "terraform"
}

variable "rds_db_port" {
  description = "DB port for RDS"
  type        = number
  default     = 3306
}

variable "ec2_name" {
  description = "name for EC2 instance"
  type        = string
  default     = "terraform-ec2-cluster"
}
variable "rds_multi_az" {
  description = "Multi AZ for RDS"
  type        = bool
  default     = true
}
variable "rds_maintenance_window" {
  description = "Maintenance window for RDS"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}
variable "rds_backup_window" {
  description = "Backup window for RDS"
  type        = string
  default     = "03:00-06:00"
}
variable "ec2_instance_count" {
  description = "instance count for EC2 instance"
  type        = number
  default     = 1
}
variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot for RDS"
  type        = bool
  default     = true
}
variable "rds_tags" {
  description = "tags for RDS"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "dev"
  }
}
variable "ec2_associate_public_ip" {
  description = "associate public ip for EC2 instance"
  type        = bool
  default     = true
}

variable "ec2_ami" {
  description = "ami for EC2 instance"
  type        = string
  default     = "ami-0885b1f6bd170450c"
}

variable "ec2_instance_type" {
  description = "instance type for EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ssh_key_name" {
  description = "ssh key name for EC2 instance"
  type        = string
  default     = "aws-terraform"
}

variable "ec2_tags" {
  description   = "Tags to apply to EC2 instance"
  type          = map(string)
  default       = {
    Terraform   = "true"
    Environment = "dev"
  }
}