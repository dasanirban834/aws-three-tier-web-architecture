################ Fetch AZs details#################
data "aws_availability_zones" "azs" {
  state = "available"
}


########################################################################
#                                                                      #
#             :: Fetch IAM roles for Administrative actions ::         #
#                                                                      #
########################################################################

data "aws_iam_role" "role" {
  name = "CustomEC2AdminAccess"
}


########################################################################
#                                                                      #
#             :: Fetch Keypair details ::                              #
#                                                                      #
########################################################################

data "aws_key_pair" "key" {
  key_name           = "keypair"
  include_public_key = true
}

########################################################################
#                                                                      #
#             :: Fetch Web SG details ::                             #
#                                                                      #
########################################################################

data "aws_security_group" "sg" {
  filter {
    name   = "tag:Layer"
    values = ["Web"]
  }
}
data "aws_security_group" "mgmt" {
  filter {
    name   = "tag:Layer"
    values = ["Management"]
  }
}

data "aws_security_group" "ext_alb" {
  filter {
    name = "tag:Name"
    values = ["InternetFacing-ALB"]
  }
}

########################################################################
#                                                                      #
#             :: Fetch Netwroking details ::                           #
#                                                                      #
########################################################################

# vpc details :
data "aws_vpc" "this_vpc" {
  state = "available"
  filter {
    name   = "tag:Name"
    values = ["custom-vpc"]
  }
}

# subnets details :
data "aws_subnet" "web_subnet_1a" {
  vpc_id = data.aws_vpc.this_vpc.id
  filter {
    name   = "tag:Name"
    values = ["weblayer-pub1-1a"]
  }
}

data "aws_subnet" "web_subnet_1b" {
  vpc_id = data.aws_vpc.this_vpc.id
  filter {
    name = "tag:Name"
    values = ["weblayer-pub2-1b"]
  }
}

# internet gateway details :
data "aws_internet_gateway" "this_igw" {
  filter {
    name   = "tag:Name"
    values = ["Internet Gateway"]
  }
}

# route table details :
data "aws_route_table" "pub_rt" {
  filter {
    name   = "tag:Name"
    values = ["custom-route-table-public"]
  }
}
data "aws_route_table" "priv_rt" {
  filter {
    name   = "tag:Name"
    values = ["custom-route-table-private"]
  }
}

# public route details :
data "aws_route" "pub_r" {
  route_table_id = data.aws_route_table.pub_rt.id
  gateway_id     = data.aws_internet_gateway.this_igw.id
}

# private route details
data "aws_route" "priv_r" {
  route_table_id = data.aws_route_table.priv_rt.id
  nat_gateway_id = data.aws_nat_gateway.ngw.id
}

#NAT Gateway details :
data "aws_nat_gateway" "ngw" {
  filter {
    name   = "tag:Name"
    values = ["NAT"]
  }
}
