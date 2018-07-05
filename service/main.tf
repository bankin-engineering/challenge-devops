data "aws_caller_identity" "current" {}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.name}-service"
  iam_role        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsServiceRole"

  // TODO
  cluster         = "?"
  // TODO
  task_definition = "${aws_ecs_task_definition.sample-definition.arn}"
  desired_count   = 1

  load_balancer {
    // TODO
    target_group_arn  = "?"
    // TODO
    container_port    = ?
    container_name    = "simple-app"
  }
}

resource "aws_ecs_task_definition" "sample-definition" {
  family                = "${var.name}-tdef"
  container_definitions = "${data.template_file.container.rendered}"
}

data "template_file" "container" {
  template        = "${file("${path.module}/task-definition.json")}"

  vars {
   image  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-1.amazonaws.com/terraform-workshop:latest"
  }
}