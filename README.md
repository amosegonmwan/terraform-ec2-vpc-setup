# Terraform AWS EC2 and VPC Setup

This project demonstrates how to use Terraform to create an EC2 instance within a VPC on AWS. The EC2 instance is an Ubuntu instance of type `t2.micro`.

## Project Structure

1. **providers.tf**: Defines the Terraform and AWS providers.
2. **variable.tf**: Defines the variables used in the Terraform configuration.
3. **vpc.tf**: Defines the VPC, subnet, internet gateway, route table, and route table association.
4. **ec2.tf**: Defines the EC2 instance.
5. **output.tf**: Defines the outputs for the public IP of the EC2 instance and the VPC ID.

## Directory Structure

Create a new folder/directory called `<your_name>-ec2` and place all the following files inside it.

## Step-by-Step Instructions

### Step 1: Create the Project Directory

Create a new directory called `terraform-ec2`:

```sh
mkdir terraform-ec2
cd terraform-ec2
```

### Step 2: Define Providers
Create a file named `providers.tf` and add the following content:
```sh
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" { 
  region = var.aws_region
}
```

### Step 3: Define Variables
Create a file named variable.tf and add the following content:
```sh
variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "keypair_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "demo-key-oregon"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-078701cc0905d44e4"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
```

### Step 4: Define VPC
Create a file named vpc.tf and add the following content:

```sh
resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "project_subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "project_subnet"
  }
}

resource "aws_internet_gateway" "project_gw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project_igw"
  }
}

resource "aws_route_table" "project_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_gw.id
  }

  tags = {
    Name = "project_rt"
  }
}

resource "aws_route_table_association" "project_rta" {
  subnet_id      = aws_subnet.project_subnet.id
  route_table_id = aws_route_table.project_rt.id
}
```


### Step 5: Create EC2 Instance
Create a file named ec2.tf and add the following content:
```sh
resource "aws_instance" "project_ec2" {
  ami = var.ami_id
  instance_type = var.ec2_instance_type
  key_name = var.keypair_name
  subnet_id = aws_subnet.project_subnet.id

  tags = {
    Name = "project_ec2"
  }
}
```

### Step 6: Define Outputs
Create a file named output.tf and add the following content:

```sh
output "ec2_public_ip" {
  value = aws_instance.project_ec2.public_ip
}

output "vpc_id" {
  value = aws_vpc.project_vpc.id
}
```
