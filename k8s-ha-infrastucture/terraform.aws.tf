provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name    = "kubernetes-the-not-so-hard-way"
  cidr    = "10.240.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.240.0.0/24"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "k8s_cluster_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  name   = "kubernetes-the-not-so-hard-way"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-icmp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      description = "Kubernetes API Server"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "all-all"
      cidr_blocks = "10.240.0.0/24"
    },
    {
      rule        = "all-all"
      cidr_blocks = "10.200.0.0/16"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "k8s_cluster_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "0.4.0"
  
  key_name   = "kubernetes_the_not_so_hard_way"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1zx282ZY9RrqSvVxwTSXI1zW9r64ReztCndfcCcTSwOriF23sZiAfwxR+odnIca6LApPf0JKp5l3Fx4JK2CO5O0QTlBDgm3KAhWeduqPvYcrY9zOq7vJG2jJFGEAwXjE9arBsJkSRqkS6k7feMEOFSWomLZQkzUDnVp2L81zc1D+Xbc/f5VSCs0v6NLt5lLnyDvgKPS06k/FboPRdVo8R7ka3BB58FHoZcM/UyQKRe981kKkr9Ou5OTN+9JcwEAn8AUxi+fwhyjE+CJ/c2ow2UWUgGOnSPhrdYc/SeCvCrNiRyvdJFkRFqp0MbKZIRnItUlaGvqPrMJzHd/xq7yAR centos@terraform"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "kubernetes_controllers" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name = "k8s-controller"
  ami  = "ami-07ebfd5b3428b6f4d"
  
  associate_public_ip_address = "true"
  
  instance_type  = "t3.medium"
  instance_count = 3
  key_name       = module.k8s_cluster_key_pair.this_key_pair_key_name 
 
  private_ips = [
    "10.240.0.11", 
    "10.240.0.12", 
    "10.240.0.13"
  ]
 
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.k8s_cluster_sg.this_security_group_id] 

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "kubernetes_workers" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  name = "k8s-worker"
  ami  = "ami-07ebfd5b3428b6f4d"

  associate_public_ip_address = "true"

  instance_type  = "t3.medium"
  instance_count = 3
  key_name       = module.k8s_cluster_key_pair.this_key_pair_key_name
 
  private_ips = [
    "10.240.0.21",
    "10.240.0.22",
    "10.240.0.23"
  ]
  
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.k8s_cluster_sg.this_security_group_id]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
