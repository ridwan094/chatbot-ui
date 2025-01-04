terraform {
  backend "s3" {
    bucket = "ridwan-terraform-backend"
    key    = "EKS/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
