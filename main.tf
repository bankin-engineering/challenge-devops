/*
* Terraform Workshop
*/

// TODO
provider "aws" {
  access_key = "?"
  secret_key = "?"
  region = "eu-west-1"
}

// TODO
locals {
  name = "CHANGE!#%"
  cidr = "?"
  region = "eu-west-1"
}


/*
* STEP 1 : Cluster
*/

module "vpc" {
  source = "./vpc"
  availability_zones = {
    eu-west-1 = ["eu-west-1a", "eu-west-1b"]
  }
  name = "${local.name}"
  cidr_block = "${local.cidr}"
  aws_region = "${local.region}"
}

module "cluster" {
  source = "./cluster"
  name = "${local.name}"
}


/*
* STEP 2 : Autoscaling
*/

module "autoscaling" {
  source = "./autoscaling"
  cluster-name = "${module.cluster.cluster-name}"
  name = "${local.name}"
  subnets = ["${module.vpc.subnets}"]
  vpc_id = "${module.vpc.vpc_id}"
  cidr_block = "${local.cidr}"
}


/*
* STEP 3 : Load Balancer
*/

module "alb" {
  source = "./load-balancer"
  name = "${local.name}"
  subnets = ["${module.vpc.subnets}"]
  vpc_id = "${module.vpc.vpc_id}"
}


/*
* STEP 4 : Service
*/

module "service" {
  source = "./service"
  name = "${local.name}"
  ecs-target-group-arn = "${module.alb.target_group_arn}"
  cluster = "${module.cluster.cluster-name}"
}



