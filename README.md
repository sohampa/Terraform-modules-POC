# AWS Infrastructure with Terraform

This Terraform project provisions essential AWS infrastructure including a **VPC**, **MySQL RDS instance**, and an **EC2 instance** using modular and reusable Terraform code.

---

## 🚀 Overview

This project is structured around Terraform modules to ensure reusability, scalability, and clean separation of concerns.

### 🔹 VPC Module
- Creates a Virtual Private Cloud (VPC)
- Configures:
  - Public and private subnets
  - Internet Gateway (IGW)
  - NAT Gateway
  - Route Tables

### 🔹 RDS Module
- Launches an **Amazon RDS MySQL** instance
- Deployed in **private subnets** for security

### 🔹 EC2 Module
- Provisions an **EC2 instance** in a **public subnet**
- Enables **SSH** and **HTTP** access via security group

---

## 📋 Prerequisites

Ensure the following tools and configurations are in place:

- [Terraform v1.5.0+](https://www.terraform.io/downloads)
- AWS CLI configured with credentials (`aws configure`)
- An active AWS account with appropriate permissions for:
  - EC2
  - RDS
  - VPC
- Existing AWS SSH key pair (e.g., `my-key-pair` in `us-east-1`)

---

## 📁 Directory Structure

project/
├── README.md # Project documentation
├── terraform.tfvars # Variable values (DO NOT commit)
├── main.tf # Module declarations
├── variables.tf # Input variable definitions
├── outputs.tf # Output values
└── modules/
├── vpc/ # VPC module
├── rds/ # RDS module
└── ec2/ # EC2 module
