terraform {
  backend "s3" {
    bucket         = "eui-terraform-backend-s3" 
    key            = "terraform/state.tfstate"  
    region         = "us-east-1"  
    profile        = "iamadmin-dev"
  }
}

