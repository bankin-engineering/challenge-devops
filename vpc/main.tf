
resource "aws_vpc" "vpc" {
  cidr_block           = "${cidrsubnet(var.cidr_block, 0, 0)}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}-vpc"
    Environment = "${var.name}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.name}-internet-gateway"
    Environment = "${var.name}"
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name        = "${var.name}-public-routetable"
    Environment = "${var.name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone       = "${element(var.availability_zones[var.aws_region], count.index)}"
  map_public_ip_on_launch = "true"
  count                   = "${length(var.availability_zones[var.aws_region])}"

  tags {
    Name        = "${var.name}-${element(var.availability_zones[var.aws_region], count.index)}-public"
    Environment = "${var.name}"
  }
}

resource "aws_route_table_association" "public_routing_table" {
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_routetable.id}"
  count          = "${length(var.availability_zones[var.aws_region])}"
}