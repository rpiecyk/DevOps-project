variable "instance_name" {
  description = "Name for the Scalc project's EC2 instance"
  type        = string
  default     = "pl.org.bash.100jokes"
}

variable "az-first" {
  description = "AZ for first subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "aws_region" {
  description = "Chosen region"
  type        = string
  default     = "eu-central-1"
}

variable "internet_cidr" {
  description = "CIDR block for Internet"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_ami" {
  description = "Chosen AMI"
  type        = string
  default     = "ami-05f7491af5eef733a"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_key_name" {
  description = "SSH key name"
  type        = string
  default     = "scalac-project-ssh-key"
}

variable "instance_key" {
  description = "SSH key"
  type        = string
  default     = "~/.ssh/aws-scalac-key.pub"
}

variable "private_key" {
  description = "SSH"
  type        = string
  default     = "~/.ssh/aws-scalac-key"
}
