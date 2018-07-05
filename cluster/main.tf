resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.name}-cluster"
}

variable "name" {
  type = "string"
}