resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "project-vpc"
  }
}
#
resource "aws_subnet" "project_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
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


