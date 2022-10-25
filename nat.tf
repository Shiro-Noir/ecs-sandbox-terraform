resource "aws_eip" "nat_gateway_1a" {
  vpc = true
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_eip" "nat_gateway_1c" {
  vpc = true
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "nat-gateway_1a" {
  allocation_id = aws_eip.nat_gateway_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "nat-gateway_1c" {
  allocation_id = aws_eip.nat_gateway_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id
  depends_on = [
    aws_internet_gateway.igw
  ]
}
