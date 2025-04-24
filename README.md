# 🚀 Final Java DevOps CI/CD Project

![Architecture Diagram](./assets/pipeline-diagram.png)

## 📘 Project Description

This is a simple Java web app deployed as a container on port `8080`, hosted on an AWS EC2 instance. The entire CI/CD pipeline is automated using industry-standard DevOps tools.

🔗 **Test URL:** `http://<webserver_eip>:8080/jpetstore`



---

## 🛠️ Infrastructure Provisioning (Terraform + AWS)

Two EC2 instances are provisioned using Terraform:
- `jenkins-ec2`  (for Jenkins server)
- `webserver-ec2`  (to host the app)
- Security Group allowing inbound traffic (SSH, HTTP)
- EIPs attached to both instances

<p align="center">
  <img src="./assets/terraform-apply.png" alt="Terraform Apply Output">
  <br>
  <em>Terraform: Infrastructure successfully provisioned</em>
</p>

<p align="center">
  <img src="./assets/ec2-instances.png" alt="EC2 Instances">
  <br>
  <em>EC2 Instances running in AWS Console</em>
</p>

<p align="center">
  <img src="./assets/elastic-ips.png" alt="Elastic IPs">
  <br>
  <em>EC2 Instances Elastic IP Addresses</em>
</p>

<p align="center">
  <img src="./assets/sg-inbound.png" alt="Security Groups">
  <br>
  <em>Inbound Security Group with SSH and HTTP access</em>
</p>




---

## 🧰 Jenkins Server Configuration

The Jenkins EC2 instance is configured via `jenkins-userdata.sh` during terraform provisioning. It automatically installs:
- Java
- Jenkins
- Maven
- Docker
- Ansible

<p align="center">
  <img src="./assets/jenkins-ui.png" alt="Jenkins UI">
  <br>
  <em>Jenkins running on EC2 at <code>http://&lt;jenkins_eip&gt;:8080</code></em>
</p>

<p align="center">
  <img src="./assets/jenkins-initial-setup.png" alt="Jenkins Initial Setup">
  <br>
  <em>Jenkins Initial Setup Wizard </em>
</p>

<p align="center">
  <img src="./assets/jenkins-dashboard.png" alt="Jenkins Dashboard">
  <br>
  <em>Jenkins Dashboard after setup</em>
</p>
---

## 🔁 GitHub to Jenkins Integration

A GitHub webhook is configured to trigger the Jenkins pipeline on every push to the `main` branch. Below is a step-by-step setup for integrating GitHub with Jenkins.

<p align="center">
  <img src="./assets/jenkins-new-item.png" alt="Jenkins New Item">
  <br>
  <em>Creating a new Pipeline job named <code>EUI-Pipeline</code> on Jenkins</em>
</p>

<p align="center">
  <img src="./assets/jenkins-item-triggers.png" alt="Jenkins Pipeline Triggers">
  <br>
  <em>Setting up SCM polling to trigger builds automatically</em>
</p>

<p align="center">
  <img src="./assets/jenkins-item-definition.png" alt="Jenkins Pipeline Definition">
  <br>
  <em>Configuring the Pipeline definition to use the Jenkinsfile from GitHub</em>
</p>

<p align="center">
  <img src="./assets/github-webhook.png" alt="GitHub Webhook Settings">
  <br>
  <em>Webhook set on GitHub to notify Jenkins on every push to <code>main</code></em>
</p>


---

## 📜 Jenkins Pipeline (Jenkinsfile)

### 🧪 CI Stages

1. **Clone Repository**  

2. **Setup Maven Wrapper**  

3. **Build the Code** (`./mvnw clean package`)  
<p align="center">
  <img src="./assets/jenkins-stage-build.png" alt="Build Stage">
  <br>
  <em>Compiling the Java application and packaging into a WAR file</em>
</p>

4. **Run Tests** (`./mvnw test`)  
<p align="center">
  <img src="./assets/jenkins-stage-test.png" alt="Test Stage">
  <br>
  <em>Running unit tests using Maven</em>
</p>

5. **Dockerize the App**  
<p align="center">
  <img src="./assets/jenkins-stage-dockerize.png" alt="Dockerize Stage">
  <br>
  <em>Building a Docker image from the WAR file</em>
</p>

6. **Push Docker Image to Docker Hub**  
<p align="center">
  <img src="./assets/docker-hub.png" alt="Docker docker-hub">
  <br>
  <em>Pushing the Docker image to Docker Hub registry</em>
</p>


### 🚀 CD Stages:

7. **Deploy** via Ansible  
<p align="center">
  <img src="./assets/jenkins-stage-deploy.png" alt="Ansible Stage">
  <br>
  <em>Deployment automation with Ansible targeting the webserver EC2</em>
</p>

8. **App Running on EC2 Webserver**  
<p align="center">
  <img src="./assets/webserver-ui.png" alt="Webserver UI">
  <br>
  <em>jPetStore running at <code>http://&lt;webserver_eip&gt;:8080/jpetstore</code></em>
</p>


---

## ⚙️ Tools Used

- **Git/GitHub** – Source control and repository hosting  
- **Maven** – Java build automation  
- **Docker** – Containerization  
- **Docker Hub** – Container registry  
- **Jenkins** – CI/CD automation  
- **Ansible** – Configuration management and deployment  
- **Terraform** – Infrastructure provisioning on AWS  
- **AWS EC2** – Hosting Jenkins and the Java web app  
