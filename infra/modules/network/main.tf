variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR"
  type        = list(string)
}

# VPC作成
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

# パブリックサブネット作成
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

# プライベートサブネット作成
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

# 出力の定義
output "vpc_id" {
  description = "作成されたVPCのID"
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "作成されたプライベートサブネットのID一覧"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "作成されたパブリックサブネットのID一覧"
  value       = aws_subnet.public[*].id
}
