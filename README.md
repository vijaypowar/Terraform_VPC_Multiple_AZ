## A Virtual Private Cloud (VPC) in two Availability Zones (AZs)
***
>This repository contains the Terraform demo project that contain creation of AWS resources. [Ensure the prerequisites as mentioned in the Terraform_VPC_Single_AZ](https://github.com/vijaypowar/Terraform_VPC_Single_AZ/blob/main/README.md "Ensure the prerequisites as mentioned in the Terraform_VPC_Single_AZ")
#### This setup is for big client. Dev & Prod environment will be in same VPC but in different AZs. This terraform template will deploy the following resources in aws cloud. 
* 1 VPC >> 10.10.0.0/16
* 2 Public Subnet >> az > 1a -> 10.10.1.0/24  (dev-public) / 1b -> 10.10.21.0/24 (prod-public)
* 2 Private Subnet >> az > 1a -> 10.10.11.0/24  (dev-private) / 1b -> 10.10.31.0/24 (prod-private)
* 2 Public Route table / Route table association 
* 2 Private route table  / Route table association
* 1 Internet Gateway >> IGW mapped with VPC 
* 2 EIP
* 2 NAT Gateway >> Created in 2 public subnets and associated with private route table

* 1 reverse proxy server in public subnet (Dev) 
* 1 Security Group for reverse proxy 
* 1 Web server in private instance (Dev)
* 1 Security Group for web server 
 

#### Naming conventions // Assume, if client name is ongc.

* VPC Name - ongc-vpc1
* Public Subnets Name - ongc-dev-public-subnet1,  ongc-prod-public-subnet1
* Private Subnetes Name- ongc-dev-private-subnet1, ongc-prod-private-subnet1
* IGW Name - ongc-igw
* Public Route Table Name- dev-pub-rt1,  prod-pub-rt1 
* Private Route Table Name- dev-priv-rt1, prod-priv-rt1
* EIP Name- dev-nat-eip, prod-nat-eip
* NAT GW Name- ongc-dev-nat, ongc-prod-nat,   // network.tf

* Instance Name- reverse-proxy,
* Security Group Name- rp-sg  // reverse-proxy.tf
* Instance Name- web-server, 
* Sec Group Name- web-sg  // web-server.tf
* Declaration of variables  // variables.tf
* Variables   // terraform.tfvars