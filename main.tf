resource "aws_instance" "control-plane" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.control-plane-sg.name}"]
  key_name        = aws_key_pair.deployer.key_name
  tags = {
    Name = var.control_plane_instance_name
  }
}

resource "aws_instance" "worker-1" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.worker-sg.name}"]
  key_name        = aws_key_pair.deployer.key_name
  tags = {
    Name = var.worker1_instance_name
  }
}

resource "aws_instance" "worker-2" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = var.ec2_instance_type
  security_groups = ["${aws_security_group.worker-sg.name}"]
  key_name        = aws_key_pair.deployer.key_name
  tags = {
    Name = var.worker2_instance_name
  }
}