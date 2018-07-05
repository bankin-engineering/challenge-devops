
data "aws_ami" "ecs" {
  most_recent = true
  name_regex = ".*ecs\\-optimized.*"
  owners = ["amazon"]
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "${var.name}-asg"
  // TODO
  max_size = "?"
  // TODO
  min_size = "?"
  // TODO
  desired_capacity = "?"
  vpc_zone_identifier = ["${var.subnets}"]
  // TODO
  launch_configuration = "?"
  health_check_type = "ELB"
}

resource "aws_security_group" "awsvpc_sg" {
  name   = "${var.name}-awsvpc-cluster-sg"
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

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "${var.name}-alc"
  // TODO
  image_id = "?"
  instance_type = "t2.micro"
  iam_instance_profile = "arn:aws:iam::965032684114:instance-profile/ecsInstanceRole"
  // TODO
  security_groups = ["?"]
  associate_public_ip_address = "true"
  key_name = "terraform-workshop"
  user_data = "${data.template_file.ecs-launch-configuration-user-data.rendered}"
}


data "template_file" "ecs-launch-configuration-user-data" {
  template = "${file("${path.module}/user-data.tpl")}"
  vars {
    ecs-cluster-name = "${var.cluster-name}"
  }
}
