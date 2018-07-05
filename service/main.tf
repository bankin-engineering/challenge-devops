resource "aws_ecs_service" "ecs-service" {
  name            = "${var.name}-service"
  iam_role        = "arn:aws:iam::965032684114:role/ecsServiceRole"

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
  container_definitions = "${file("${path.module}/task-definition.json")}"
}