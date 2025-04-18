terraform {
  backend "s3" {
    bucket         = "terraform-tfstatefile-storage-bucket"
    dynamodb_table = "terraform-lock-table"
    region         = "eu-north-1"
    key            = "terraform/terraform.tfstate"
    encrypt        = true
  }
}
