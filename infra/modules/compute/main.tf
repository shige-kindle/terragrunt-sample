variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the instance will be launched"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be launched"
}

variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

resource "aws_security_group" "this" {
  name        = "compute-sg"
  description = "Security group for compute instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # VPC内からのSSHアクセスのみ許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
}
