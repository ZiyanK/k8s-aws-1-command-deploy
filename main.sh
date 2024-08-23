# Create a ssh public and private key
ssh-keygen -t rsa -b 2048 -f aws-ec21 -N ''

# Setup infrastructure
terraform apply -auto-approve

# Wait for 10 seconds for VMs to startup properly
sleep 8

# Setup control-plane
control_plane_ip=`terraform output control_plane_instance_public_ip | tr -d '"'`
echo "$control_plane_ip"
ssh -i aws-ec2 -o ConnectTimeout=5 -o StrictHostKeyChecking=no ubuntu@$control_plane_ip 'exit'
scp -i aws-ec2 setup-control-plane.sh ubuntu@$control_plane_ip:~/.
ssh -i aws-ec2 ubuntu@$control_plane_ip << EOF
    sudo su
    chmod +x setup-control-plane.sh
    ./setup-control-plane.sh
EOF
join_command=$(ssh -i aws-ec2 ubuntu@$control_plane_ip 'sudo kubeadm token create --print-join-command')
echo $join_command

# Setup worker node 1
worker1_node_ip=`terraform output worker1_instance_public_ip | tr -d '"'`
echo "$worker1_node_ip"
ssh -i aws-ec2  -o StrictHostKeyChecking=no ubuntu@$worker1_node_ip 'exit'
scp -i aws-ec2 setup-worker.sh ubuntu@$worker1_node_ip:~/.
ssh -i aws-ec2 ubuntu@$worker1_node_ip << EOF
    sudo su
    chmod +x setup-worker.sh
    ./setup-worker.sh
EOF
echo "Ended script for worker 1"
ssh -i aws-ec2 -o StrictHostKeyChecking=no ubuntu@$worker1_node_ip << EOF
    sudo su
    $join_command --ignore-preflight-errors IsPrivilegedUser
EOF

# Setup worker node 2
worker2_node_ip=`terraform output worker2_instance_public_ip | tr -d '"'`
echo "$worker2_node_ip"
ssh -i aws-ec2 -o StrictHostKeyChecking=no ubuntu@$worker2_node_ip 'exit'
scp -i aws-ec2 setup-worker.sh ubuntu@$worker2_node_ip:~/.
ssh -i aws-ec2 ubuntu@$worker2_node_ip << EOF
    sudo su
    chmod +x setup-worker.sh
    ./setup-worker.sh
EOF
ssh -i aws-ec2 -o StrictHostKeyChecking=no ubuntu@$worker2_node_ip "$join_command"
ssh -i aws-ec2 -o StrictHostKeyChecking=no ubuntu@$worker2_node_ip << EOF
    sudo su
    $join_command --ignore-preflight-errors IsPrivilegedUser
EOF