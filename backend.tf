terraform {
  backend "s3" {
    bucket = "backend-tf-soham"
    key    = "envs/terraform.tfstate"
    region = "us-east-1"
  }
}