resource "aws_lb" "ingress_alb" {
  name = "${var.project}-${var.environment}-ingress_alb"
  internal = false # public ALB
  security_groups = [ data.aws_ssm_parameter.ingress_sg_id.value ]
  subnets = split(",",data.aws_ssm_parameter.public_subnet_ids.value)


  enable_deletion_protection = false

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project}-${var.environment}-ingress_alb"
        }
    )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from web http</h1>"
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port = "443"
  protocol = "HTTPS"

  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from web https</h1>"
      status_code = "200"
    }
  }
}

resource "aws_lb_target_group" "frontend" {
  name = "${var.project}-${var.environment}-frontend"
  port = "80"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path = "/"
    port = 8080
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100  # less number will be first validated

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
  condition {
    host_header {
      values = ["expense-${var.environment}.${var.zone_name}"]
    }
  }
}


module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"
  version = "~>2.0"

  zone_name = var.zone_name

  records = [
    {
        name = "expense-${var.environment}"
        type = "A"
        allow_overwrite = true
        alias = {
            name = aws_lb.ingress_alb.name
            zone_id = aws_lb.ingress_alb.zone_id
        }

    }
  ]
}