resource "aws_s3_bucket" "remote-backend-bucket" {
  bucket = "terraform-tfstatefile-storage-bucket"

  tags = {
    Name        = "Remote Backend Bucket"
  }
}