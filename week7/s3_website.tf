import {
  to = aws_s3_bucket.example
  id = "testbucketforskkuding"
}

variable "region" {
    default = "ap-northeast-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "testbucketforskkuding" # give a unique bucket name
  tags = {
    Name = "testbucketforskkuding"
  }
}


resource "aws_s3_bucket_website_configuration" "s3" {
    bucket = aws_s3_bucket.example.id 

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }

    routing_rule {
        condition {
            key_prefix_equals = "/"
        }
        redirect {
            replace_key_prefix_with = "/"
        }
    }   
  
}

# s3 static website url

output "website_url" {
    value = aws_s3_bucket_website_configuration.s3.website_endpoint
}