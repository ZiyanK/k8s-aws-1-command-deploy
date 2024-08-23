variable "control_plane_instance_name" {
  description = "Value of the control plane EC2 instance name"
  type        = string
}

variable "worker1_instance_name" {
  description = "Value of the first worker EC2 instance name"
  type        = string
}

variable "worker2_instance_name" {
  description = "Value of the second worker EC2 instance name"
  type        = string
}

variable "ec2_instance_type" {
  description = "Value of the instance type used for EC2"
  type        = string
}

variable "ec2_ubuntu_ami" {
  description = "Value of the AMI used"
  type        = string
}

variable "key_name" {
  description = "Value of the key name used to access the server"
  type        = string
}

variable "VPC_IPv4_CIDR" {
  description = "Value of the IPv4 adress of the default VPC"
  type        = string
  default     = "172.31.0.0/16"
}