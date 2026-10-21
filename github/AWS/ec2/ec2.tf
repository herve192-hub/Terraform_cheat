terraform {
  # Require Terraform features available in 1.5 and later.
  required_version = ">= 1.5.0"

  # Pin the AWS provider to compatible v5 releases.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # The region can be changed with the aws_region input variable.
  region = var.aws_region
}

# Use the account's default VPC rather than creating a new network.
data "aws_vpc" "default" {
  default = true
}

# Find subnets in that VPC; the instance uses the first returned subnet.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Resolve the latest Amazon Linux 2023 x86_64 AMI published by AWS in this region.
data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Permit public web requests while leaving SSH closed.
resource "aws_security_group" "web" {
  name_prefix = "terraform-ec2-web-"
  description = "Allow HTTP traffic to the example web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow public HTTP requests"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow the instance to reach package repositories and other destinations.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-web"
  }
}

resource "aws_instance" "example" {
  # Use the current Amazon Linux 2023 image and configurable instance size.
  ami           = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = var.instance_type
  # Place the instance in the default VPC and assign it a public IP for the demo site.
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  # Install and start Apache on first boot, then create a simple landing page.
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    printf '<h1>Hello from Terraform on Amazon EC2</h1>\n' > /var/www/html/index.html
  EOF

  root_block_device {
    # Encrypt the root volume at rest.
    encrypted = true
  }

  metadata_options {
    # Require IMDSv2 for instance metadata requests.
    http_tokens = "required"
  }

  tags = {
    Name = var.instance_name
  }
}
