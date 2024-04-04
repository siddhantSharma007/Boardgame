# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "MyVPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "MyIGW"
  }
}

# Create Subnet A (Web Tier)
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name = "SubnetA"
  }
}

# Create a Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  
  tags = {
    Name = "MyRouteTable"
  }
}

# Create a route in the Route Table to send all traffic to the Internet Gateway
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_instance" "web_ec2_instance" {
  ami                    = "ami-007020fd9c84e18c7"  # Replace with your desired AMI ID for web tier
  key_name               = "Project"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  associate_public_ip_address = true  # Assign a public IP to the web server
  
  tags = {
    Name = "WebEC2Instance"
  }
}


