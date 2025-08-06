variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "http_port" {
  description = "HTTP port for web access"
  type        = number
  default     = 80
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket containing the JAR file"
  type        = string
}

variable "s3_jar_key" {
  description = "S3 key (path) to the JAR file"
  type        = string
}

variable "user_data" {
  description = "User data script for EC2 instance"
  type        = string
}
variable "instance_profile_name" {
  
}