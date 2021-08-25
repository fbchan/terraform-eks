variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}


data "aws_availability_zones" "available" {}

locals {
  //cluster_name = "education-eks-${random_string.suffix.result}"
  cluster_name = "foobz-eks1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "foobz-eks1"
  cidr                 = "10.6.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets  = ["10.6.21.0/24", "10.6.22.0/24", "10.6.23.0/24"]
  public_subnets   = ["10.6.11.0/24", "10.6.12.0/24", "10.6.13.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

// Manually add
resource "aws_subnet" "foobz-eks1-voltmesh-ext-subnet-1" {
    vpc_id = module.vpc.vpc_id
    availability_zone  = "ap-southeast-1a"
    map_public_ip_on_launch = "true"
    cidr_block  = "10.6.31.0/24"
    tags = {
        Name = "foobz-eks1-voltmesh-ext-subnet-1"
    }
}

resource "aws_subnet" "foobz-eks1-voltmesh-ext-subnet-2" {
    vpc_id = module.vpc.vpc_id
    availability_zone  = "ap-southeast-1b"
    map_public_ip_on_launch = "true"
    cidr_block  = "10.6.32.0/24"
    tags = {
        Name = "foobz-eks1-voltmesh-ext-subnet-2"
    }
}

resource "aws_subnet" "foobz-eks1-voltmesh-ext-subnet-3" {
    vpc_id = module.vpc.vpc_id
    availability_zone  = "ap-southeast-1c"
    map_public_ip_on_launch = "true"
    cidr_block  = "10.6.33.0/24"
    tags = {
        Name = "foobz-eks1-voltmesh-ext-subnet-3"
    }
}