output "control_plane_instance_public_ip" {
  description = "Public IP address of the control plane EC2 instance"
  value       = aws_instance.control-plane.public_ip
}

output "worker1_instance_public_ip" {
  description = "Public IP address of the Worker 1 EC2 instance"
  value       = aws_instance.worker-1.public_ip
}

# output "worker2_instance_public_ip" {
#   description = "Public IP address of the Worker 2 EC2 instance"
#   value       = aws_instance.worker-2.public_ip
# }