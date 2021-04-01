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
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  default     = ["us-east-1a"]
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
#   default     = ["10.20.7.0/24", "10.20.8.0/24", "10.20.9.0/24"]
  default     = ["10.20.7.0/24"]
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

# ec2 instances
variable "ec2_name" {
  description = "name for EC2 instance"
  type        = string
  default     = "terraform-ec2-cluster"
}
variable "ec2_instance_count" {
  description = "instance count for EC2 instance"
  type        = number
  default     = 1
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
#   default     = "m5.xlarge"
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

# elb variables
variable "elb_name" {
    description = "Name for ELB"
    type        = string
    default     = "terraform-web-elb"
}
variable "elb_internal" {
    description = "Internal flag for ELB"
    type        = bool
    default     = false
}
variable "elb_listeners" {
  description   = "Listener maps for ELB"
  type          = list(map(string))
  default       = [
      {
        instance_port     = 80
        instance_protocol = "HTTP"
        lb_port           = 80
        lb_protocol       = "HTTP"
        # ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    }
  ]
}
variable "elb_health_checks" {
    description = "Health checks map for ELB"
    type        = map(string)
    default     = {
        target              = "HTTP:80/"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
  }
}
variable "elb_tags" {
  description   = "Tags to apply to the ELB"
  type          = map(string)
  default       = {
    Owner       = "Terraform"
    Terraform   = "true"
    Environment = "dev"
  }
}

## rds variables
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

variable "rds_publicly_accessible" {
  description   = "Make RDS instance publicly accessible"
  type          = bool
  default       = false
}

variable "rds_retention_period" {
  description   = "retention period for RDS"
  type          = number
  default       = 0
}

variable "rds_deletion_protection" {
  description   = "RDS deletion protection"
  type          = bool
  default       = false
}