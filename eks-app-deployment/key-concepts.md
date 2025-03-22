# Key Concepts in EKS Deployment  

This document provides a high-level overview of key components used in deploying applications on **Amazon EKS**, ensuring efficient traffic management, security, and scalability.  

## 1. EKS Cluster & Fargate  

- **EKS** provides a **managed Kubernetes control plane**, handling cluster operations like scaling, updates, and security.  
- **Fargate** acts as a **serverless data plane**, automatically provisioning and scaling pods without managing EC2 instances.  
- Using Fargate eliminates the need to provision worker nodes, reducing operational complexity and cost.  

## 2. Application Load Balancer (ALB) & Ingress Controller  

- **ALB** manages external traffic, providing **layer 7 routing**, security, and scalability.  
- **Ingress Controller** integrates with ALB to dynamically configure routing based on ingress rules.  

## 3. IAM Roles, OIDC Authentication & IRSA  

- **OIDC (OpenID Connect)** allows EKS to use AWS IAM for authentication, securely linking Kubernetes service accounts with AWS IAM roles.  
- **IAM Roles for Service Accounts (IRSA)** enables pods to assume IAM roles dynamically instead of using long-lived credentials.  
- This setup improves security by allowing **fine-grained access control**, ensuring each pod only has the permissions it needs.  

### Example Use Case in This Project  
In this deployment, the **ALB Ingress Controller** running in the EKS cluster requires access to AWS APIs for provisioning and managing the **Application Load Balancer**. Instead of using static credentials, we configure **IRSA**, allowing the ALB controller to assume an IAM role with the necessary permissions. This ensures secure, automated load balancer provisioning without manual credential management.  

## 4. Target Groups & Traffic Routing  

- **Target Groups** dynamically register pods as ALB targets, distributing requests efficiently.  
- ALB and the ingress controller work together to route requests based on domain names or path rules.  
- This improves **high availability**, ensuring traffic is distributed across healthy pods.  

## Summary  

1. **EKS & Fargate** simplify Kubernetes cluster and workload management without infrastructure overhead.  
2. **ALB & Ingress Controller** expose services securely with intelligent traffic routing.  
3. **OIDC & IRSA** provide secure, identity-based access to AWS services for Kubernetes workloads.  
4. **Target Groups** ensure efficient traffic distribution and high availability for application pods.  

---