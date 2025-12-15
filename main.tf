terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # change if needed
}

resource "aws_instance" "example" {
  ami           = "ami-0df7a207adb9748c7" # Ubuntu 22.04 (Singapore)
  instance_type = "t3.micro"

  tags = {
    Name = "terraform-ec2"
  }
}
