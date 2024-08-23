# Setup a Kubernetes Cluster on AWS EC2 with just 1 command

I've been learning kubernetes for sometime now and I use an AWS account to run experiments and implement what I learn. But it is annoying to setup multiple EC2 instances, install kubernetes and then having to connect them. I wanted to set up my k8s cluster with minimal effort running just a few commands. In this case, just ONE.

## Prerequisites

1. AWS credentails should be configured
2. [Terraform](https://github.com/hashicorp/terraform) should be installed

## How to use

```
git clone https://github.com/ZiyanK/k8s-aws-1-command-deploy
cd k8s-aws-1-command-deploy
./main.sh
```

## Read more about this
To know more about this repository, you can read my medium article linked below

https://medium.com/@ziyankarmali786/setup-a-kubernetes-cluster-on-aws-ec2-with-just-1-command-43ed1a66a8b8