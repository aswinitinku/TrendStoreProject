provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "trend-vpc"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

# IAM Role for EC2 / EKS
resource "aws_iam_role" "jenkins_ec2_role" {
  name = "jenkins-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# EC2 for Jenkins
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2
  instance_type = "t2.medium"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = "taskkeypair"
  associate_public_ip_address = true
}

