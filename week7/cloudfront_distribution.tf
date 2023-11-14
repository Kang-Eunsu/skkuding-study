resource "aws_s3_bucket_acl" "example_acl" {
    bucket = aws_s3_bucket.example.id
    acl = "private"
    depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership ]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
    bucket = aws_s3_bucket.example.id
    rule {
        object_ownership = "ObjectWriter"
    }
  
}

locals{
    s3_origin_id = "mainS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.example.bucket_regional_domain_name
        origin_id = local.s3_origin_id
    }
    enabled = true
    is_ipv6_enabled = true
    comment = "OS Info Main Page"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", PATCH]
        cached_methods = [ "GET", "HEAD" ]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
        
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations = []
        }
    }
    viewer_certificate{
        cloudfront_default_certificate = true
    }
    
}