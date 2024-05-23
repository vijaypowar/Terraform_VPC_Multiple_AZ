# lab002_A Virtual Private Cloud (VPC) in two Availability Zones (AZs) //This is for big client, 
# Dev & Prod will be in same VPC but in different subnet.
# ------------------------------------------------------------------------------------------
# This terraform template deploys a following resources. 
# 1 VPC >> 10.10.0.0/16
# 2 Public Subnet >> az > 1a -> 10.10.1.0/24  / 1b -> 10.10.21.0/24
# 2 Private Subnet >> az > 1a -> 10.10.11.0/24  / 1b -> 10.10.31.0/24
# 1 Public Route table / Route table association
# 1 Private route table  / Route table association
# 1 reverse proxy server in public subnet 
# 1 Security Group for reverse proxy 
# 1 Web server in private instance 
# 1 Security Group for web server 
# 1 Internet Gateway >> IGW mapped with VPC 
# 2 NAT Gateway >> Created in 2 public subnets and associated with private route table 
#--------------------------------------------------------------------------------------------
# Naming conventions //Suppose client Name is ongc
# VPC Name - ongc-vpc1, 
# Subnets Name - ongc-dev-public-subnet1, ongc-prod-public-subnet1, ongc-dev-private-subnet1, ongc-prod-private-subnet1
# IGW Name - ongc-igw,
# Route Table Name- ongc-pub-rt, ongc-priv-rt 
# NAT GW Name- ongc-dev-nat, ongc-prod-nat,   ///network.tf
# Instance Name- reverse-proxy,
# Security Group Name- rp-sg  //reverse-proxy.tf
# Instance Name- web-server, 
# Sec Group Name- web-sg  //web-server.tf
# Declaration of variables  // variables.tf
# Variables   //terraform.tfvars