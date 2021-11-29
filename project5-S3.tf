
# aws_s3_bucket

resource "aws_s3_bucket" "project5-s3" {
  bucket = "my-tf-project5-s3-bucket"
  acl    = "private"

  tags = {
    Name        = "project5-s3"
    Environment = "test"
  }
}

