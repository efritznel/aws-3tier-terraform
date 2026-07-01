resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, { Name = "${var.env}-vpc" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.env}-public-subnet-${count.index + 1}" })
}

resource "aws_subnet" "private_web" {
  count             = length(var.private_web_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_web_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.env}-private-web-subnet-${count.index + 1}" })
}

resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.env}-private-app-subnet-${count.index + 1}" })
}

resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.env}-private-db-subnet-${count.index + 1}" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.env}-igw" })
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.env}-nat-eip" })
}

# Single NAT gateway in the first public subnet. For production HA,
# set nat_gateway_per_az = true and provision one per AZ.
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(var.tags, { Name = "${var.env}-nat-gw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.env}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.env}-private-rt" })
}

resource "aws_route_table_association" "private_web" {
  count          = length(aws_subnet.private_web)
  subnet_id      = aws_subnet.private_web[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}
