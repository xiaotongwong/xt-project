resource "aws_acm_certificate" "gitea_cert" {
  domain_name       = "gitea-xt.run.place"
  validation_method = "DNS"
}

resource "aws_route53_zone" "gitea_zone" {
  name = "gitea-xt.run.place"
}

resource "aws_route53_record" "gitea_dns" {
  zone_id = aws_route53_zone.gitea_zone.zone_id
  name    = "gitea-xt.run.place"
  type    = "A"

  alias {
    name                   = aws_lb.gitea_alb.dns_name
    zone_id                = aws_lb.gitea_alb.zone_id
    evaluate_target_health = true
  }
}