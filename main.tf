terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
resource "aws_iam_role" "ec2_role" {
  name = "EC2AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}


module "vpc" {
  # source              = "./modules/vpc"
  source              = "github.com/sohampa/Terraform-modules-POC//modules/vpc?ref=main"
  project_name        = var.project_name
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "rds" {
  source              = "./modules/rds"
  db_name             = var.db_name
  project_name        = var.project_name
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.vpc_cidr
  private_subnet_ids  = module.vpc.private_subnet_ids
  db_username         = var.db_username
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  multi_az            = var.multi_az
  depends_on = [ module.vpc ]
}

module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  region            = var.region
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  http_port         = var.http_port
  s3_bucket_name    = var.s3_bucket_name
  s3_jar_key        = var.s3_jar_key
  instance_profile_name = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    sudo apt install openjdk-17-jdk -y
    sudo apt update && sudo apt upgrade -y
    sudo apt install unzip curl -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws s3 cp s3://${var.s3_bucket_name}/${var.s3_jar_key} /home/ubuntu/Lab12-Backend-0.0.1-SNAPSHOT.jar
    chmod +x /home/ubuntu/Lab12-Backend-0.0.1-SNAPSHOT.jar
    RDS_ENDPOINT=$(terraform output -raw rds_endpoint) DB_USERNAME=${var.db_username} DB_PASSWORD=${var.db_password} nohup java -jar Lab12-Backend-0.0.1-SNAPSHOT.jar > app.log 2>&1 &

  EOF
  depends_on = [ module.rds ]
}