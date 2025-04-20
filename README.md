# 🌩️ AWS Cloud Lab

AWS Cloud Lab is a structured collection of hands-on infrastructure projects that demonstrate real-world implementations of cloud architectures using Amazon Web Services (AWS). Each project focuses on a specific use case, from deploying applications on ECS and EKS to setting up VPCs, static sites, serverless APIs, infrastructure automation with Terraform and many more.

## 📁 Repository Overview
This repository is organized into modular projects, each addressing a specific AWS architecture or deployment use case

| Folder | Description |
|--------|-------------|
| [`custom-vpc-with-ec2-autoscaling`](./custom-vpc-with-ec2-autoscaling) | Builds a production-grade VPC with **public/private subnets**, **NAT Gateway**, and **EC2 Auto Scaling** and **Application Load Balancer**  |
| [`ecs-cicd-automation`](./ecs-cicd-automation) | Automates the deployment of a containerized application using **Amazon ECS Fargate**, **CodePipeline**, and **CodeBuild** |
| [`eks-fargate-deployment`](./eks-fargate-deployment) | Deploys Kubernetes workloads with **Amazon EKS**, **Severless Farget** and **AWS ALB** showcasing high availability, scaling, and cluster management |
| [`serverless-url-shortener`](./serverless-url-shortener) | Implements a serverless URL shortener using **AWS Lambda**, **API Gateway**, **DynamoDB**, **S3**, **IAM**  and **CloudWatch** |
| [`static-website-hosting`](./static-website-hosting) | Demonstrates static website hosting with **Amazon S3** and **CloudFront** for global content delivery |
| [`terraform-remote-backend`](./terraform-remote-backend) | Sets up a remote backend using **S3** and **DynamoDB** for Terraform state management and locking |

## Technologies & Services

- **Core AWS Services**: ECS, EKS, EC2, S3, Lambda, API Gateway, DynamoDB, CloudFront, VPC, IAM, NAT Gateway  
- **Infrastructure as Code**: Terraform  
- **Automation Tools**: AWS CodePipeline, CodeBuild  
- **Architecture Design**: High availability, scalability, and secure networking  

## Usage

Each project directory includes:
- Architecture overview and infrastructure diagram  
- Step-by-step deployment instructions  
- Terraform configurations

Projects are standalone and can be deployed independently.


## License
This project is licensed under the [MIT License](LICENSE).
