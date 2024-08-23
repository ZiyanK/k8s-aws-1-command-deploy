terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("${path.module}/aws-ec2.pub")
}


resource "aws_instance" "control-plane" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.control-plane-sg.name}"]
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = var.control_plane_instance_name
  }
}

resource "aws_instance" "worker-1" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.worker-sg.name}"]
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = var.worker1_instance_name
  }
}

resource "aws_instance" "worker-2" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.worker-sg.name}"]
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = var.worker2_instance_name
  }
}

resource "aws_security_group" "control-plane-sg" {
  name        = "control-plane-sg"
  description = "Allow traffic to k8s control plane"

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API server ingress"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API server (private network only)"
    from_port   = 10250
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.VPC_IPv4_CIDR]
  }

  ingress {
    description = "Kubelet, Kube-scheduler and kube controller (private network only)"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.VPC_IPv4_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "worker-sg" {
  name        = "worker-sg"
  description = "Allow traffic to k8s workers"

  ingress {
    description = "Nodeport all traffic"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.VPC_IPv4_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}