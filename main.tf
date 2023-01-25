############### VPC Creation #####################
resource "aws_vpc" "myvpc1" {
        instance_tenancy = "default"
        cidr_block = "100.10.0.0/16"
        tags = {
                Name = "Pavan-vpc"
                }
}

############### Internet gateway #####################
resource "aws_internet_gateway" "myigw1" {
        vpc_id = aws_vpc.myvpc1.id
        tags = {
                Name = "Pavan-igw1"
                }
}

############### Subnet Creation #####################
resource "aws_subnet" "mysubnet1" {
        vpc_id = aws_vpc.myvpc1.id
        cidr_block = "100.10.0.0/24"
        map_public_ip_on_launch = true
        tags = {
                Name = "Pavan-subnet1"
                }

}
############### Route Table Creation #####################
resource "aws_route_table" "myroute1"{
        vpc_id = aws_vpc.myvpc1.id
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.myigw1.id
                }
}

############### Route Table association with Subnet #####################
resource "aws_route_table_association" "myrw_association1"{
        subnet_id = aws_subnet.mysubnet1.id
        route_table_id = aws_route_table.myroute1.id
}

############### Security Group with ssh and http allow  #####################
resource "aws_security_group" "mysg1" {
  name        = "mysg1_allow_ssh_http"
  vpc_id      = aws_vpc.myvpc1.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

