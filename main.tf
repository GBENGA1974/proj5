# Main VPC

resource "aws_vpc" "project5-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project5-VPC"
  }
}


# PUBLIC SUBNET1

resource "aws_subnet" "project5-PUB1-SUB1" {
  vpc_id     = aws_vpc.project5-VPC.id
  cidr_block = "10.0.23.0/24"

  tags = {
    Name = "project5-PUB1-SUB1"
  }
}

# PUBLIC SUBNET2

resource "aws_subnet" "project5-PUB2-SUB2" {
  vpc_id     = aws_vpc.project5-VPC.id
  cidr_block = "10.0.24.0/24"

  tags = {
    Name = "project5-PUB2-SUB2"
  }
}

# PRIVATE SUBNET1

resource "aws_subnet" "project5-PRIV1-SUB3" {
  vpc_id     = aws_vpc.project5-VPC.id
  cidr_block = "10.0.25.0/24"

  tags = {
    Name = "project5-PRIV1-SUB3"
  }
}

# PRIVATE SUBNET2

resource "aws_subnet" "project5-PRIV2-SUB4" {
  vpc_id     = aws_vpc.project5-VPC.id
  cidr_block = "10.0.26.0/24"

  tags = {
    Name = "project5-PRIV2-SUB4"
  }
}



# PUBLIC ROUTE TABLE

resource "aws_route_table" "project5-PUBLIC-RT" {
  vpc_id = aws_vpc.project5-VPC.id

  tags = {
    Name = "project5-PUBLIC-RT"
  }
}

# PRIVATE ROUTE TABLE

resource "aws_route_table" "project5-PRIVATE-RT" {
  vpc_id = aws_vpc.project5-VPC.id

  tags = {
    Name = "project5-PRIVATE-RT"
  }
}

# PUBLIC SUBNET1 ASSOCIATION WITH PUBLIC ROUTE TABLE

resource "aws_route_table_association" "project5-PUBSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project5-PUB1-SUB1.id
  route_table_id = aws_route_table.project5-PUBLIC-RT.id
}

# PUBLIC SUBNET2 ASSOCIATION WITH PUBLIC ROUTE TABLE

resource "aws_route_table_association" "project5-PUBSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project5-PUB2-SUB2.id
  route_table_id = aws_route_table.project5-PUBLIC-RT.id
}

# PRIVATE SUBNET1 ASSOCIATION WITH PRIVATE ROUTE TABLE

resource "aws_route_table_association" "project5-PRIVSUB3-ASSOC-PRIV-RT" {
  subnet_id      = aws_subnet.project5-PRIV1-SUB3.id
  route_table_id = aws_route_table.project5-PRIVATE-RT.id
}

# PRIVATE SUBNET2 ASSOCIATION WITH PRIVATE ROUTE TABLE

resource "aws_route_table_association" "project5-PRIVSUB4-ASSOC-PRIV-RT" {
  subnet_id      = aws_subnet.project5-PRIV2-SUB4.id
  route_table_id = aws_route_table.project5-PRIVATE-RT.id
}



# INTERNET GATEWAY

resource "aws_internet_gateway" "project5-igw" {
  vpc_id = aws_vpc.project5-VPC.id

  tags = {
    Name = "project5-igw"
  }
}


# IGW ASSOCIATION WITH ROUTE TABLE

resource "aws_route" "Assoc-public-RT" {
  route_table_id            = aws_route_table.project5-PUBLIC-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.project5-igw.id
}


# Allocate Elastic IP Address (EIP1)
#terraform aws allocate elastic IP

resource "aws_eip" "project5-eip-for-natgw-1" {
  vpc        = true
  depends_on = [aws_internet_gateway.project5-igw]

  tags       = {
    Name     = "project5-eip-for-natgw-1"
  }
}


# Allocate Elastic IP Address (EIP2)

resource "aws_eip" "project5-eip-for-natgw-2" {
  vpc        = true
  depends_on = [aws_internet_gateway.project5-igw]

  tags       = {
    Name     = "project5-eip-for-natgw-2"
  }
}

# NAT GATEWAY

resource "aws_nat_gateway" "project5-natgw" {
  allocation_id = aws_eip.project5-eip-for-natgw-1.id
  subnet_id     = aws_subnet.project5-PUB1-SUB1.id

  tags = {
    Name = "project5-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.project5-igw]
}

