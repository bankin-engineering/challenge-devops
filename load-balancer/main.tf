resource "aws_alb" "ecs-load-balancer" {
  name                = "${var.name}-alb"
  // TODO
  security_groups     = ["?"]
  subnets             = ["${var.subnets}"]
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.name}-awsvpc-cluster-alb"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535

    // TODO
    cidr_blocks = [
      ["?"],
    ]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    // TODO
    cidr_blocks = ["?"]
  }

  tags {
    Name        = "${var.name}-ecs-cluster-sg"
    Environment = "${var.name}"
  }
}

resource "aws_alb_target_group" "ecs-target_group" {
  name                = "${var.name}-tg"
  port                = "80"
  protocol            = "HTTP"
  vpc_id              = "${var.vpc_id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_listener" "alb-listener" {
  // TODO
  load_balancer_arn = "?"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    // TODO
    target_group_arn = "?"
    type             = "forward"
  }
}