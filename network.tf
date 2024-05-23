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
  cidr_block = cidrsubnet(var.cidr_block, 8, 0) 
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
  // 8 > It will add +8 mask to current cidr_block // 10 > It select 11th subnet from the range
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
  cidr_block = cidrsubnet(var.cidr_block, 8, 5) 
  // 8 > It will add +8 mask to current cidr_block // 5 > It select sixth subnet from the range
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
  cidr_block = cidrsubnet(var.cidr_block, 8, 15) 
  // 8 > It will add +8 mask to current cidr_block // 15 > It select 16th subnet from the range
  map_public_ip_on_launch = false
  availability_zone = var.avail_zones[1]  //0> Select second availability zone from list

  tags = {
    Name = "ongc-prod-private-subnet1"
    Type = "Private"
  }
}

# Add internet gateway
resource "aws_internet_gateway" "ongc_igw" {
    vpc_id = "${aws_vpc.eb-vpc1.id}"
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

# Public rt-1
resource "aws_route_table" "eb_vpc1_pub_rt1" {
    vpc_id = "${aws_vpc.eb-vpc1.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.eb_vpc1_igw.id}" 
    }
    
    tags = {
        Name = "eb-vpc1-pub-rt1"
    }
}

# Public Route Table Association
resource "aws_route_table_association" "eb_vpc1_pub_rt1_sub1"{
    subnet_id = "${aws_subnet.eb_vpc1_public_subnet1.id}"
    route_table_id = "${aws_route_table.eb_vpc1_pub_rt1.id}"
}

# Private rt-1
resource "aws_route_table" "eb_vpc1_priv_rt1" {
    vpc_id = "${aws_vpc.eb-vpc1.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.eb_vpc1_nat_gw.id}" 
    }
    
    tags = {
        Name = "eb-vpc1-priv-rt1"
    }
}

# Private Route Table Association
resource "aws_route_table_association" "eb_vpc1_priv_rt1_sub1"{
    subnet_id = "${aws_subnet.eb-vpc1-private-subnet1.id}"
    route_table_id = "${aws_route_table.eb-vpc1-priv-rt1.id}"
}
