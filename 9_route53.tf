data "aws_route53_zone" "public_hosted_zone" {
  name         = join(".", slice(split(".", var.domain_name), 1, 3))
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.public_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [ aws_instance.public.public_ip ]
}