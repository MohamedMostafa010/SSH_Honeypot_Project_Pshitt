# SSH Honeypot Deployment with Terraform on Azure

This project deploys an SSH Honeypot on Microsoft Azure using Terraform. The honeypot is configured to log unauthorized access attempts and integrates with [AbuseIPDB_pshitt](https://github.com/MohamedMostafa010/AbuseIPDB_pshitt.git) for passive SSH attack detection. Additionally, it reports suspicious IP addresses to [AbuseIPDB](https://www.abuseipdb.com/) for threat intelligence sharing.

## Overview

We use Terraform to automate the deployment of an Ubuntu-based virtual machine acting as an SSH honeypot. The infrastructure includes:

- A **Virtual Network** and **Subnet**
- A **Public IP Address** assigned to the honeypot
- A **Network Security Group (NSG)** allowing SSH, HTTP, and HTTPS traffic
- A **Virtual Machine (VM)** running Ubuntu 24.04 LTS
- Integration with **pshitt** and **AbuseIPDB** to analyze and report malicious activity

## Terraform Configuration

The infrastructure is defined in `SSH_Honeypot_Deploy.tf`. Below is an overview of key Terraform resources:

- **Virtual Network & Subnet:** Creates an isolated environment for the honeypot.
- **Public IP & NSG Rules:** Allows SSH (port 22), HTTP (port 80), and HTTPS (port 443) traffic.
- **Virtual Machine:** Deploys an Ubuntu 24.04 LTS VM with password authentication enabled.

### Deployment Steps

1. **Install Terraform**  
   Download and install Terraform from [Terraform's official site](https://developer.hashicorp.com/terraform/downloads).

2. **Clone the Repository**  
   ```sh
   git clone https://github.com/your-repo/ssh-honeypot-deploy.git
   cd ssh-honeypot-deploy
   ```

3. **Upload Terraform File**
   
4. **Initialize Terraform**
   ```sh
   terraform init
   ```

5. **Plan Deployment**
   ```sh
   terraform plan
   ```

6. **Deploy Infrastructure**
   ```sh
   terraform apply -auto-approve
   ```
