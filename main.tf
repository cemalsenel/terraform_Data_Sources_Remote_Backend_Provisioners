terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
  backend "s3" {
    bucket = "tf-remote-s3-bucket-jimmy"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-remote-state-lock"
    encrypt = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  ## profile = "my-profile"
}

locals {
  instance-name = "jimmy"
}


data "aws_ami" "tf-ami" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf-ami.id
  instance_type = "t2.micro"
  key_name      = "firstkey"
  tags = {
    Name = "${local.instance-name}-this is from my-ami"
  }
}


