variable "s3_bucket_name" {
    default = "testbucketforskkuding"
}

data "aws_iam_policy_document" "example" {
    statement {
        sid = "PublicReadGetObject"

        actions = [
            "s3:GetObject"
        ]
        resources = [
            "arn:aws:s3:::${var.s3_bucket_name}"
        ]
        condition {
            test     = "StringLike"
            variable = "s3:prefix"

            values = [
                "",
            ]
        }
    }
  
}

resource "aws_iam_policy" "example" {
  name   = "example_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_example_bucket_policy_data.json
}

data "aws_iam_policy_document" "s3_example_bucket_policy_data"{
    
    statement {
        sid = "1"

        actions = ["s3:GetObject"]
        effect =  "Allow"
        resources = [
            "arn:aws:s3:::${var.s3_bucket_name}",
            "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
}

resource "aws_s3_bucket_policy" "s3_example_policy" {
    bucket = aws_s3_bucket.example.id
    policy = data.aws_iam_policy_document.s3_example_bucket_policy_data.json
}



resource "aws_s3_bucket_public_access_block" "example" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false 
}