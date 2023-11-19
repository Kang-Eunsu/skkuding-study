provider "aws" {
    region = "ap-northeast-2"
}

# S3 Bucket for backend
resource "aws_s3_bucket" "tfstate" {
    bucket = "tf101-eunsu-tfstate"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
    name = "terraform-lock"
    hash_key = "LockID"
    billing_mode = "PAY_PER_REQUEST"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}
