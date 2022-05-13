# Configure the AWS Provider
provider "aws" {
  region  = "us-west-2"
  access_key = "xxxxxxx"
  secret_key = "xxxxxxx"
}

# Create a VPC
resource "aws_vpc" "Ram_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {    Name = "Ram_vpc"  }
}

resource "aws_subnet" "Ram_public_subnet" {
  vpc_id            = aws_vpc.Ram_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {    Name = "Ram_public_subnet"  }
}

resource "aws_internet_gateway" "Ram_IGW" {
  vpc_id = aws_vpc.Ram_vpc.id

  tags = {    Name = "Ram_IGW"  }
}

resource "aws_route_table" "Ram_RT" {
  vpc_id = aws_vpc.Ram_vpc.id

  route {    
cidr_block = "0.0.0.0/0"
#cidr_block = "10.0.1.0/24" Error:  destination (10.0.1.0/24)
    gateway_id = aws_internet_gateway.Ram_IGW.id  
}

  route {    
ipv6_cidr_block = "::/0"
    gateway_id  = aws_internet_gateway.Ram_IGW.id  
}

  tags = {    Name = "Ram_RT"  }
}

resource "aws_security_group" "Ram_SGrp" {
  name   = "SSH 22, Custom 8080 and HTTP 80"
  vpc_id = aws_vpc.Ram_vpc.id

  ingress {
from_port   = 22
to_port     = 22
protocol   = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
self               = false
}

  ingress {
from_port   = 8080
to_port     = 8080
protocol     = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
self               = false
}

  ingress {
from_port   = 80
to_port     = 80
protocol     = "tcp"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
self               = false
}

  tags = {    Name = "Ram_SGrp"  }
 
}
