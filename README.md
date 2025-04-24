# 🚀 **Java DevOps CI/CD Project** – *End-to-End Automation on AWS*

<p align="center">
  <img src="./assets/pipeline-diagram.png" alt="Architecture Diagram" width="80%">
  <br>
  <em>CI/CD Pipeline Architecture Diagram</em>
</p>

---

## **Project Overview**

This project demonstrates a fully automated DevOps pipeline for deploying a **Java web application**.

### Tools used:
- 🧱 Built with Maven & Docker
- 🔄 Integrated CI/CD via Jenkins
- 📦 Containerized and pushed to Docker Hub
- ☁️ Deployed on AWS EC2 using Ansible
- 🧩 Infrastructure provisioned using Terraform

🔗 **Live Demo:**  
http://<webserver_eip>:8080/jpetstore

---

## **Infrastructure Provisioning** *(Terraform + AWS)*

Two EC2 instances are provisioned:
- `jenkins-ec2` – for Jenkins  
- `webserver-ec2` – for hosting the Java web app  
- Security Group: SSH (22) & HTTP (80) access  
- Elastic IPs assigned to both instances

<p align="center">
  <img src="./assets/terraform-apply.png" alt="Terraform Apply Output">
  <br>
  <em>Terraform: Infrastructure successfully provisioned</em>
</p>

<p align="center">
  <img src="./assets/ec2-instances.png" alt="EC2 Instances">
  <br>
  <em>EC2 Instances shown in AWS Console</em>
</p>

<p align="center">
  <img src="./assets/elastic-ips.png" alt="Elastic IPs">
  <br>
  <em>Elastic IP addresses associated with instances</em>
</p>

<p align="center">
  <img src="./assets/sg-inbound.png" alt="Security Groups">
  <br>
  <em>Security Group allows inbound SSH and HTTP traffic</em>
</p>

---

## **Jenkins Server Setup**

Configured via `jenkins-userdata.sh` during provisioning. Installs:
- Java  
- Jenkins  
- Maven  
- Docker  
- Ansible  

<p align="center">
  <img src="./assets/jenkins-ui.png" alt="Jenkins UI">
  <br>
  <em>Jenkins running on EC2: <code>http://&lt;jenkins_eip&gt;:8080</code></em>
</p>

<p align="center">
  <img src="./assets/jenkins-initial-setup.png" alt="Jenkins Initial Setup">
  <br>
  <em>Jenkins Initial Setup Wizard</em>
</p>

<p align="center">
  <img src="./assets/jenkins-dashboard.png" alt="Jenkins Dashboard">
  <br>
  <em>Jenkins Dashboard after setup</em>
</p>

---

## **GitHub to Jenkins Integration**

A GitHub webhook is set up to trigger builds on every push to the `main` branch.

<p align="center">
  <img src="./assets/jenkins-new-item.png" alt="Jenkins New Item">
  <br>
  <em>Creating a new Pipeline job: <code>EUI-Pipeline</code></em>
</p>

<p align="center">
  <img src="./assets/jenkins-item-triggers.png" alt="Jenkins Triggers">
  <br>
  <em>Configuring SCM polling to auto-trigger builds</em>
</p>

<p align="center">
  <img src="./assets/jenkins-item-definition.png" alt="Pipeline Definition">
  <br>
  <em>Linking to GitHub repo using Jenkinsfile</em>
</p>

<p align="center">
  <img src="./assets/github-webhook.png" alt="GitHub Webhook">
  <br>
  <em>GitHub Webhook to notify Jenkins</em>
</p>

---

## **Jenkins CI/CD Pipeline**

### Continuous Integration (CI)

1. **Clone Repository**  
2. **Setup Maven Wrapper**  
3. **Build with** `./mvnw clean package`  
<p align="center">
  <img src="./assets/jenkins-stage-build.png" alt="Build Stage">
  <br>
  <em>Java app compiled into a WAR file</em>
</p>

4. **Run Unit Tests**  
<p align="center">
  <img src="./assets/jenkins-stage-test.png" alt="Test Stage">
  <br>
  <em>Maven runs automated unit tests</em>
</p>

5. **Dockerize Application**  
<p align="center">
  <img src="./assets/jenkins-stage-dockerize.png" alt="Dockerize">
  <br>
  <em>Docker image built from the WAR file</em>
</p>

6. **Push Docker Image to Docker Hub**  
<p align="center">
  <img src="./assets/docker-hub.png" alt="Docker Hub">
  <br>
  <em>Image pushed to Docker Hub</em>
</p>

---

### Continuous Deployment (CD)

7. **Deploy via Ansible**  
<p align="center">
  <img src="./assets/jenkins-stage-deploy.png" alt="Ansible Output">
  <br>
  <em>App deployed to webserver EC2 via Ansible</em>
</p>

8. **App Running on EC2 Webserver**  
<p align="center">
  <img src="./assets/webserver-ui.png" alt="Webserver UI">
  <br>
  <em>jPetStore available at <code>http://&lt;webserver_eip&gt;:8080/jpetstore</code></em>
</p>

---


