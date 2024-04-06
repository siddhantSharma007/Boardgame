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
  availability_zone = "us-west-2a"
  
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

# Create Security Group
resource "aws_security_group" "my_sg" {
  name        = "MySecurityGroup"
  description = "Allow inbound traffic on port 80 and 22"
  vpc_id      = aws_vpc.my_vpc.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "web_ec2_instance" {
  ami                    = "ami-0395649fbe870727e"  # Replace with your desired AMI ID for web tier
  key_name               = "data"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  
  tags = {
    Name = "WebEC2Instance"
  }

  provisioner "local-exec" {
    # Wait until the instance is in the "running" state
    # This command uses the AWS CLI to check the instance state
    command = <<-EOT
      until [ "$(aws ec2 describe-instances --instance-ids ${self.id} --query 'Reservations[].Instances[].State[].Name' --output text)" = "running" ]; do
        echo "Waiting for the EC2 instance to be in the running state..."
        sleep 5
      done
    EOT
  }
}

output "public_ip" {
  value = aws_instance.web_ec2_instance.public_ip
}



