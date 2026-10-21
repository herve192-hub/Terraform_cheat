# AWS region in which to create the EC2 instance.
# Defaults to us-east-1 if no value is provided.
variable "aws_region" {
  description = "AWS region in which to create the EC2 instance"
  type        = string
  default     = "us-east-1"
}

# EC2 instance type to launch.
# Defaults to t3.micro if no value is provided.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Name tag assigned to the EC2 instance.
# Defaults to terraform-example if no value is provided.
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "terraform-example"
}
