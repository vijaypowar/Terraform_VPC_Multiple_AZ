# Variables for setting up terraform
aws_region     = "us-east-1"
my_credentials = ["C:\Users\Vijay\.ssh\id_rsa.pub"]
my_profile     = "tf-user"

# Variables for Creating the VPC and Subnets
avail_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
cidr_block    = "10.10.0.0/16"

# Variables for creating instances
instance_type = "t3.micro"
ebs_size = "10"
my_ip = ""
ami_id = "ami-051f0947e420652a9"