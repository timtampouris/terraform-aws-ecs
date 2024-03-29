### Network

# Internet VPC

resource "aws_vpc" "ecs-vpc" {
  cidr_block           = "172.21.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "ecs-terraform"
  }
}

# Subnets
resource "aws_subnet" "ecs-public-1" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags {
    Name = "ecs-public-1"
  }
}

resource "aws_subnet" "ecs-public-2" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.20.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags {
    Name = "ecs-public-2"
  }
}

resource "aws_subnet" "ecs-public-3" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1c"

  tags {
    Name = "ecs-public-3"
  }
}

resource "aws_subnet" "ecs-private-1" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.40.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags {
    Name = "ecs-private-1"
  }
}

resource "aws_subnet" "ecs-private-2" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.50.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags {
    Name = "ecs-private-2"
  }
}

resource "aws_subnet" "ecs-private-3" {
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  cidr_block              = "172.21.60.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1c"

  tags {
    Name = "ecs-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "ecs-gw" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  tags {
    Name = "ecs-IG"
  }
}

# route tables
resource "aws_route_table" "ecs-public" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecs-gw.id}"
  }

  tags {
    Name = "ecs-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "ecs-public-1-a" {
  subnet_id      = "${aws_subnet.ecs-public-1.id}"
  route_table_id = "${aws_route_table.ecs-public.id}"
}

resource "aws_route_table_association" "ecs-public-2-a" {
  subnet_id      = "${aws_subnet.ecs-public-2.id}"
  route_table_id = "${aws_route_table.ecs-public.id}"
}

resource "aws_route_table_association" "ecs-public-3-a" {
  subnet_id      = "${aws_subnet.ecs-public-3.id}"
  route_table_id = "${aws_route_table.ecs-public.id}"
}
