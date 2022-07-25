# Resource: ACM Certificate
resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "*.cmcloudlab441.info"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
   }
}