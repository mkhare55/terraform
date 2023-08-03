resource "aws_lb" "aws_lb" {
  name               = "ASGLoadbalancer"
  internal           = false
  load_balancer_type = "application" #"application" or "network"
  security_groups    = var.vpc_security_group_ids    #[aws_security_group.lb_sg.id]
  subnets            = var.psubnet_id           #[for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false #true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = merge({ "Name" = "ASGLoadbalancer" }, var.tags)
}

resource "aws_lb_target_group" "aws_lb_target_group" {
  name        = "tg-ASGLoadbalancer"
  port        = 80
  protocol    = "HTTP"    #"HTTP"
  target_type = "instance" #"ip" for ALB/NLB, "instance" for autoscaling group, 
  vpc_id      = var.vpc_id
  tags        = merge({ "Name" = "tg-ASGLoadbalancer" }, var.tags)
  depends_on  = [aws_lb.aws_lb]
}

resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port              = 80     #"443"
  protocol          = "HTTP" #"TLS"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_target_group.arn
  }
}

output "lb_id" {
  description = "LB id"
  value       = try(aws_lb.aws_lb.id, "")
}

output "lb_arn" {
  description = "LB ARN"
  value       = try(aws_lb.aws_lb.arn, "")
}

output "lb_tg_id" {
  description = "LB Target group id"
  value       = try(aws_lb_target_group.aws_lb_target_group.id, "")
}

output "lb_tg_arn" {
  description = "LB Target group ARN"
  value       = try(aws_lb_target_group.aws_lb_target_group.arn, "")
}









