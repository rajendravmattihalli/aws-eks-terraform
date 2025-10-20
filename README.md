# aws-eks-terraform
Terraform project to provision an Amazon EKS Cluster on AWS. By leveraging Infrastructure as Code (IaC), we automate the deployment of Kubernetes clusters with modular and reusable Terraform configurations.

**Architecture**
<img width="1536" height="1024" alt="Architecture" src="https://github.com/user-attachments/assets/aefa1c67-0877-4b03-9f40-fad0faf6595e" />

**Project Structure**
```
.
├── main.tf
├── modules
│   ├── EKS
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── IAM
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── policies
│   │   │   ├── argocd-policy.json
│   │   │   └── prometheus-policy.json
│   │   └── variables.tf
│   ├── Key-Pair
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── Security_groups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── VPC
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── provider.tf
├── README.md
├── terraform.tfvars
└── variables.tf
```

1. modules/EKS – Manages EKS cluster deployment.
2. modules/VPC – Handles VPC and networking setup.
3. modules/IAM – Handles VPC and networking setup.
4. modules/Security_groups – Handles VPC and networking setup.
5. modules/Key-Pair – Handles VPC and networking setup.
6. provider.tf – Defines the AWS provider.
7. main.tf – Root Terraform script to call modules.
8. terraform.tfvars – variable assigments.


**Prerequisites**
1. Terraform
2. AWS CLI
3. Kubectl CLI

**Installation Steps**
1. Clone the repository
> git clone 
2. Setup aws credentials
> aws configure
3. Run terraform initialization
> terraform init
4. Run terraform validation
> terraform validate
5. Run terraform plan
> terraform plan
6. Run terraform apply
> terraform apply
7. Configure kubectl
> curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.17/2023-05-11/bin/linux/amd64
> openssl sha1 -sha256 kubectl
> ./kubectl version --short --client
8. Run update kubeconfig
> aws eks update-kubeconfig --name aws-eks-cluster --region us-east-1
9. Verify cluster
> kubectl get nodes





