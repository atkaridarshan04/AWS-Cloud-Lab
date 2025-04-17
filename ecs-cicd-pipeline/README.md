# 🚀 Automated App Deployment using ECR, ECS (Fargate) & CodePipeline

## Project Overview

This project demonstrates how to **fully automate the deployment** of a containerized **Application** on **Amazon ECS (Fargate)** using **Amazon ECR** for container image storage, and **AWS CodePipeline** with **CodeBuild** for CI/CD.  
The setup ensures that every code change pushed to GitHub triggers a pipeline that builds a Docker image, pushes it to ECR, and seamlessly deploys it to ECS via an Application Load Balancer (ALB).

## Architecture
![architecture](./assets/ecs-cicd-architecture.png)

## 🔄 How the Complete Project Works

1. **You push code to GitHub.**
2. **CodePipeline** detects the change and starts execution.
3. **CodeBuild**:
   - Builds a Docker image of your app.
   - Pushes the image to **Amazon ECR**.
   - Generates an `imagedefinitions.json` file.
4. **CodePipeline** passes the image definition to **ECS**.
5. **ECS (Fargate)**:
   - Pulls the latest image from ECR.
   - Updates the running containers behind a **Load Balancer**.
6. **Your app is live** at the Load Balancer DNS—no manual deployment needed.


## 🛠️ AWS Services Used

| Service          | Purpose                                                                 |
|------------------|-------------------------------------------------------------------------|
| **Amazon ECR**   | Store Docker images securely                                            |
| **Amazon ECS**   | Deploy and run containers on serverless infrastructure (Fargate)       |
| **AWS CodeBuild**| Build Docker images and push to ECR                                     |
| **AWS CodePipeline** | Automate CI/CD pipeline from GitHub to ECS                          |
| **Amazon S3**    | Store build artifacts                                                   |
| **IAM**          | Manage permissions across services                                      |
| **Elastic Load Balancer (ALB)** | Distribute traffic to ECS services                      |


## Step-by-Step Deployment Guide (AWS Console)

### 1️⃣ Push Code to GitHub

1. Create a GitHub repository (e.g., `container-orchestration`).
2. Push this folder code into your github repo.

---

### 2️⃣ Create ECR Repository

1. Go to **Amazon ECR > Private Repositories > Create repository**.
2. Name it: `container-orchestration-repo`.
3. Leave the rest as default and click **Create**.
    ![ecr-1](./assets/ecr-1.png)
4. Note the ECR URI:  
   ```
   <aws_account_id>.dkr.ecr.<region>.amazonaws.com/container-orchestration-repo
   ```

    ![ecr-2](./assets/ecr-2.png)   

---

### 3️⃣ Create an S3 Bucket for Artifacts

1. Go to **Amazon S3 > Create bucket**.
2. Name it something like: `my-artifacts-1234`.
3. (Optional) Disable “Block all public access” if you need access logs/debugging.
4. Click **Create Bucket**.

    ![s3-1](./assets/s3-1.png)

---

### 4️⃣ Create IAM Roles and Permissions

- Ensure the following IAM roles exist:
  ![iam-1](./assets/iam-1.png)

- Attack necessary policies to build pipeline service role:
  ![iam-2](./assets/iam-2.png)

- Attack necessary policies to codepipeline pipeline service role:
  ![iam-3](./assets/iam-3.png)

---

### 5️⃣ Create CodeBuild Project

1. Go to **CodeBuild > Create build project**.
2. Project Name: `build-pipeline`.
    ![build-1](./assets/build-1.png)
3. Source: **GitHub** (connect your repository).
    ![build-2](./assets/build-2.png)
4. Enable Webhook to auto-trigger on commits.
    ![build-3](./assets/build-3.png)
5. Environment:
   - Image: Managed Ubuntu
   - Runtime: Standard
   - Enable “Privileged” for Docker-in-Docker
   - Service Role: `codebuild-react-build-pipeline-service-role`
      
    ![build-4](./assets/build-4.png)
6. Add Buildspec configuration:
    ![build-05](./assets/build-05.png)
6. Add Artifacts
    - Type: Amazon S3
    - Select the bucket created
    - Enable Semantic Versioning
    
    ![build-5](./assets/build-5.png)
7. Leave Rest Default
    ![build-6](./assets/build-6.png)  
    ![build-7](./assets/build-7.png)  

---

### 6️⃣ Create ECS Cluster & Task Definition

#### a. Create ECS Cluster

1. Navigate to **ECS > Clusters > Create Cluster**.
2. Choose: **Networking only (Fargate)**.
3. Name it: `ProdCluster`.
    ![ec2-1](./assets/ecs-1.png)
    ![ec2-2](./assets/ecs-2.png)

#### b. Create Task Definition

1. Go to **Task Definitions > Create new**.
2. Launch type: `AWS Farget`
3. Task Role: Use or create `ECSTaskExecutionRole`.
    ![task-1](./assets/task-1.png)
4. Container Details:
   - Name: `app-container`
   - Image URI:  
     ```
     <ecr-repo-uri>:latest
     ```
   - Port Mappings: 5173 (or whichever your app runs on)

   ![task-2](./assets/task-2.png)

5. Click **Create**.

#### c. Create ECS Service

1. Go to `ProdCluster > Services > Create`.
    ![service-2](./assets/service-2.png)
2. Task definition: Choose the one you just created.
3. Desired count: `2`
    ![service-3](./assets/service-3.png)
    ![service-4](./assets/service-4.png)
4. Networking:
   - Use default VPC and subnets
   - Assign security group allowing inbound on port **5173**
5. Attach an **Application Load Balancer (ALB)**.
    ![service-5](./assets/service-5.png)
    ![service-6](./assets/service-6.png)
6. Enable **Service Auto Scaling**.
    ![service-7](./assets/service-7.png)
7. Leave rest, click create:
    ![service-8](./assets/service-8.png)
---

### 7️⃣ Create CodePipeline

1. Navigate to **CodePipeline > Create pipeline**.
2. Pipeline Name: `prod-pipeline`
3. Service Role: Choose **New Service Role**
    ![cp-1](./assets/cp-1.png)
4. Artifact Store: Select the S3 bucket (`my-pipeline-artifacts-1234`)
    ![cp-2](./assets/cp-2.png)

#### a. Source Stage

- Provider: GitHub (connect account)
- Repo & branch: select your repo and branch (e.g., `main`)
    ![cp-3](./assets/cp-3.png)

#### b. Build Stage

- Provider: **CodeBuild**
- Project: `build-pipeline`
    ![cp-4](./assets/cp-4.png)

#### c. Test Stage
- Skpi test stage

#### d. Deploy Stage

- Provider: **Amazon ECS**
- Cluster: `ProdCluster`
- Service Name: Your ECS service name
- Image Definitions File: `imagedefinitions.json`
    ![cp-5](./assets/cp-5.png)

5. Preview and click create pipeline.


## ✅ Verify

1. **Wait for the pipeline to complete.**  
    ![cp-6](./assets/cp-6.png)

2. **Check ECR** to ensure the latest Docker image has been uploaded.
    ![ecr-3](./assets/ecr-3.png)

3. **Go to your S3 bucket** and confirm that `imagedefinitions.json` has been uploaded as a build artifact.
    <!-- ![s3-3](./assets/s2) -->

4. **Go to the CloudFormation stack** created by ECS/CodePipeline.  
   ![cf](./assets/cf.png)

5. **Open EC2 > Load Balancers**, copy the **ALB DNS name**, and visit it in your browser to verify the app is live.
    ![alb](./assets/alb.png)
    ![web-v1](./assets/web-v1.png)

6. **Edit your app source code** and push the changes to GitHub.
    ![github-1](./assets/github-1.png)

7. **Once the pipeline finishes again**, check ECR for a new image version and verify the updated app via the ALB URL in your browser.
    ![cp-7](./assets/cp-7.png)
    ![ecr-4](./assets/ecr-4.png)
    ![web-v2](./assets/web-v2.png)

    ![cp-8](./assets/cp-8.png)
    ![github-2](./assets/github-2.png)


## Cleanup Resources

To avoid unwanted AWS charges, delete:

- CloudFormation stacks
- ECR repositories
- CodePipeline & CodeBuild projects
- ECS Cluster
- S3 bucket (optional)

---
