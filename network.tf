# VPC
resource "aws_vpc" "ongc_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "ongc-vpc"
  }
}

# Public Subnet in first AZ
resource "aws_subnet" "ongc_dev_public_subnet1" {
  vpc_id     = aws_vpc.ongc_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 1) 
  // 8 > It will add +8 mask to current cidr_block // 0 > It select first subnet from the range
  map_public_ip_on_launch = true
  availability_zone = var.avail_zones[0]  //0> Select first availability zone from list

  tags = {
    Name = "ongc-dev-public-subnet1"
    Type = "Public"
  }
}

# Public Subnet in second AZ
resource "aws_subnet" "ongc_prod_public_subnet1" {
  vpc_id     = aws_vpc.ongc_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 10) 
  // 8 > It will add +8 mask to current cidr_block // 20 > It select 21st subnet from the range
  map_public_ip_on_launch = true
  availability_zone = var.avail_zones[1]  //1> Select second availability zone from list

  tags = {
    Name = "ongc-prod-public-subnet1"
    Type = "Public"
  }
}

# Private Subnet in First AZ
resource "aws_subnet" "ongc_dev_private_subnet1" {
  vpc_id     = aws_vpc.ongc_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 10) 
  // 8 > It will add +8 mask to current cidr_block // 11 > It will select 11th subnet from the range
  map_public_ip_on_launch = false
  availability_zone = var.avail_zones[0]  //0> Select first availability zone from list

  tags = {
    Name = "ongc-dev-private-subnet1"
    Type = "Private"
  }
}


# Private Subnet in second AZ
resource "aws_subnet" "ongc_prod_private_subnet1" {
  vpc_id     = aws_vpc.ongc_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 30) 
  // 8 > It will add +8 mask to current cidr_block // 41 > It select 31st subnet from the range
  map_public_ip_on_launch = false
  availability_zone = var.avail_zones[1]  //1> Select second availability zone from list

  tags = {
    Name = "ongc-prod-private-subnet1"
    Type = "Private"
  }
}

# Add internet gateway
resource "aws_internet_gateway" "ongc_igw" {
    vpc_id = "${aws_vpc.ongc_vpc.id}"
    tags = {
        Name = "ongc-igw"
    }
}

# (Dev)NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "dev_nat_eip" {
    vpc = true
}
resource "aws_nat_gateway" "dev_nat_gw" {
    allocation_id = aws_eip.dev_nat_eip.id
    subnet_id     = "${aws_subnet.ongc_dev_public_subnet1.id}"

    tags = {
    Name = "dev-nat-gw"
    
    depends_on = [aws_internet_gateway.ongc_igw]
    }
}

# (Prod) NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "prod_nat_eip" {
    vpc = true
}
resource "aws_nat_gateway" "prod_nat_gw" {
    allocation_id = aws_eip.prod_nat_eip.id
    subnet_id     = "${aws_subnet.ongc_prod_public_subnet1.id}"

    tags = {
    Name = "prod-nat-gw"
    
    depends_on = [aws_internet_gateway.ongc_igw]
    }
}

# Dev Public Route Table1
resource "aws_route_table" "dev_pub_rt1" {
    vpc_id = "${aws_vpc.ongc_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ongc_igw.id}" 
    }
    
    tags = {
        Name = "dev-pub-rt1"
    }
}

# Dev Public Route Table Association
resource "aws_route_table_association" "dev_pub_rt1_sub1"{
    subnet_id = "${ongc_dev_public_subnet1}"
    route_table_id = "${aws_route_table.dev_pub_rt1}"
}

# Prod Public Route Table1
resource "aws_route_table" "prod_pub_rt1" {
    vpc_id = "${aws_vpc.ongc_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ongc_igw.id}" 
    }
    
    tags = {
        Name = "prod-pub-rt1"
    }
}

# Prod Public Route Table Association
resource "aws_route_table_association" "prod_pub_rt1_sub1"{
    subnet_id = "${ongc_prod_public_subnet1}"
    route_table_id = "${aws_route_table.prod_pub_rt1}"
}

# Dev Private Route Table1
resource "aws_route_table" "dev_priv_rt1" {
    vpc_id = "${aws_vpc.ongc_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.dev_nat_gw.id}" 
    }
    
    tags = {
        Name = "dev-priv-rt1"
    }
}

# Dev Private Route Table Association
resource "aws_route_table_association" "dev_priv_rt1_sub1"{
    subnet_id = "${aws_subnet.ongc_dev_private_subnet1.id}"
    route_table_id = "${aws_route_table.dev_priv_rt1.id}"
}

# Prod Private Route Table1
resource "aws_route_table" "prod_priv_rt1" {
    vpc_id = "${aws_vpc.ongc_vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.prod_nat_gw.id}" 
    }
    
    tags = {
        Name = "prod-priv-rt1"
    }
}

# Prod Private Route Table Association
resource "aws_route_table_association" "prod_priv_rt1_sub1"{
    subnet_id = "${aws_subnet.ongc_prod_private_subnet1.id}"
    route_table_id = "${aws_route_table.prod_priv_rt1.id}"
}

