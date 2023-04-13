# vpc details :
data "aws_vpc" "this_vpc" {
  state = "available"
  filter {
    name   = "tag:Name"
    values = ["custom-vpc"]
  }
}

# subnets details :
data "aws_subnet" "db_subnet_1a" {
  vpc_id = data.aws_vpc.this_vpc.id
  filter {
    name   = "tag:Name"
    values = ["dblayer-priv1-1a"]
  }
}

data "aws_subnet" "db_subnet_1b" {
  vpc_id = data.aws_vpc.this_vpc.id
  filter {
    name   = "tag:Name"
    values = ["dblayer-priv2-1b"]
  }
}

# DB Security group details:
data "aws_security_group" "sg" {
  filter {
    name   = "tag:Layer"
    values = ["DB"]
  }
}