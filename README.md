# SSH Honeypot Deployment with Terraform on Azure

This project deploys an SSH Honeypot on Microsoft Azure using Terraform. The honeypot is configured to log unauthorized access attempts and integrates with [AbuseIPDB_pshitt](https://github.com/MohamedMostafa010/AbuseIPDB_pshitt.git) for passive SSH attack detection. Additionally, it reports suspicious IP addresses to [AbuseIPDB](https://www.abuseipdb.com/) for threat intelligence sharing.

## Overview

We use Terraform to automate the deployment of an Ubuntu-based virtual machine acting as an SSH honeypot. The infrastructure includes:

- A **Virtual Network** and **Subnet**
- A **Public IP Address** assigned to the honeypot
- A **Network Security Group (NSG)** allowing SSH, HTTP, and HTTPS traffic
- A **Virtual Machine (VM)** running Ubuntu 24.04 LTS
- Integration with **pshitt** and **AbuseIPDB** to analyze and report malicious activity

## Modifications & Enhancements  

- We have improved the original **pshitt** SSH honeypot by integrating it with **AbuseIPDB**, allowing real-time threat intelligence reporting. These enhancements provide:  
   - **Automatic reporting** of malicious SSH attempts to [AbuseIPDB](https://www.abuseipdb.com/)  
   - **Better logging** of captured credentials, attack sources, and metadata  
   - **Improved compatibility** with modern Python versions and security modules  
   - **Forked & enhanced version:** [AbuseIPDB_pshitt](https://github.com/MohamedMostafa010/AbuseIPDB_pshitt.git)  

- This forked version of `pshitt` ensures a more **efficient, real-time, and scalable** way to track SSH attacks, making it an excellent tool for honeypot monitoring.  

## Terraform Configuration

The infrastructure is defined in `SSH_Honeypot_Deploy.tf`. Below is an overview of key Terraform resources:

- **Virtual Network & Subnet:** Creates an isolated environment for the honeypot.
- **Public IP & NSG Rules:** Allows SSH (port 22), HTTP (port 80), and HTTPS (port 443) traffic.
- **Virtual Machine:** Deploys an Ubuntu 24.04 LTS VM with password authentication enabled.

## Deployment Steps

1. **Install Terraform**  
   Download and install Terraform from [Terraform's official site](https://developer.hashicorp.com/terraform/downloads).

2. **Clone the Repository**  
   ```sh
   git clone https://github.com/MohamedMostafa010/SSH_Honeypot_Project_Pshitt.git
   cd SSH_Honeypot_Project_Pshitt
   ```

3. **Upload Terraform File**  
   <img src="assets/1-Uploading.png" alt="Step 1 - Upload" width="500">
   <img src="assets/2-Uploaded.png" alt="Step 2 - Confirmation" width="500">
   
4. **Initialize Terraform**
   ```sh
   terraform init
   ```

5. **Plan Deployment**
   ```sh
   terraform plan
   ```

6. **Deploy Infrastructure (Until the below green message displayed)**
   ```sh
   terraform apply -auto-approve
   ```
   <img src="assets/3-Terraform Plan.png" alt="Step 3 - Green Message" width="500">

- Honeypot Virtual Machine Deployed, let's Setup the Honeypot Tool on it.
  
## AbuseIPDB Installation and Setup

1. **Access the Honeypot**
   ```sh
   ssh azureuser@<public-ip>
   ```
   <img src="assets/4-SSHing.png" alt="Step 4 - SSHing" width="500">

2. **Ensure Dependencies are Installed**
   ```sh
   sudo apt-get update -y
   sudo apt-get install -y git python3 python3-pip python3-dev libssl-dev libffi-dev build-essential python3-venv python3-daemon python3-pycryptodome python3-paramiko python3-zope.interface
   ```

3. **Disable SSH Entirely (Optional, but better if you want a dedicated SSH Honeypot Server)**
   ```sh
   sudo systemctl disable ssh.socket
   sudo systemctl stop ssh.socket
   sudo systemctl disable ssh
   sudo systemctl stop ssh
   ```

4. **Clone the New Integrated Pshitt (AbuseIPDB_pshitt)**
   ```sh
   git clone --verbose https://github.com/MohamedMostafa010/AbuseIPDB_pshitt.git
   cd AbuseIPDB_pshitt
   ```

5. **Run this SSH Honeypot Tool (You can change the port, also the File Name and Path)**
   ```sh
   chmod +x pshitt.py
   sudo ./pshitt.py -p 22 -o /home/azureuser/credentials.json
   ```
- Now the Honeypot Tool "AbuseIPDB_pshitt" is Listening on Port 22 (Acting as it is a real SSH Server)

## Sample of Data when Executing

1. **Trying Login Attempts**
   ```sh
   C:\Users\moham>ssh user@13.88.14.101
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added '13.88.14.101' (RSA) to the list of known hosts.
   user@13.88.14.101's password:
   Permission denied, please try again.
   user@13.88.14.101's password:
   Permission denied, please try again.
   user@13.88.14.101's password:
   user@13.88.14.101: Permission denied (password,publickey).
   ```
   
2. **Captured Credentials/Information (Image and Text have the same data)**
   <img src="assets/6-Captured Information.png" alt="Step 6 - Captured Information" width="500">
   ```sh
   {"username": "user", "password": "CoMpLeEx!", "src_ip": "156.214.155.185", "src_port": 64641, "timestamp": "2025-02-09T04:04:42.519138", "software_version": "OpenSSH_for_Windows_9.5", "cipher": "aes128-ctr", "mac": "hmac-sha2-256-etm@openssh.com", "try": 1, "abuseipdb": {"ipAddress": "156.214.155.185", "isPublic": true, "ipVersion": 4, "isWhitelisted": null, "abuseConfidenceScore": 0, "countryCode": "EG", "usageType": "Fixed Line ISP", "isp": "TE Data", "domain": "tedata.net", "hostnames": ["host-156.214.185.155-static.tedata.net"], "isTor": false, "totalReports": 0, "numDistinctUsers": 0, "lastReportedAt": null}}
   {"username": "user", "password": "WrOnGpAsS", "src_ip": "156.214.155.185", "src_port": 64641, "timestamp": "2025-02-09T04:04:49.241704", "software_version": "OpenSSH_for_Windows_9.5", "cipher": "aes128-ctr", "mac": "hmac-sha2-256-etm@openssh.com", "try": 2, "abuseipdb": {"ipAddress": "156.214.155.185", "isPublic": true, "ipVersion": 4, "isWhitelisted": null, "abuseConfidenceScore": 0, "countryCode": "EG", "usageType": "Fixed Line ISP", "isp": "TE Data", "domain": "tedata.net", "hostnames": ["host-156.214.185.155-static.tedata.net"], "isTor": false, "totalReports": 0, "numDistinctUsers": 0, "lastReportedAt": null}}
   {"username": "user", "password": "It_Is_A_Honeypot$$", "src_ip": "156.214.155.185", "src_port": 64641, "timestamp": "2025-02-09T04:05:07.210905", "software_version": "OpenSSH_for_Windows_9.5", "cipher": "aes128-ctr", "mac": "hmac-sha2-256-etm@openssh.com", "try": 3, "abuseipdb": {"ipAddress": "156.214.155.185", "isPublic": true, "ipVersion": 4, "isWhitelisted": null, "abuseConfidenceScore": 0, "countryCode": "EG", "usageType": "Fixed Line ISP", "isp": "TE Data", "domain": "tedata.net", "hostnames": ["host-156.214.185.155-static.tedata.net"], "isTor": false, "totalReports": 0, "numDistinctUsers": 0, "lastReportedAt": null}}
   ```
- The honeypot logs crucial attack data, including source IPs, usernames, passwords, encryption methods, and software versions. This information can help in:

   - **Threat Intelligence:** Identifying attack patterns and malicious IPs.
   - **Incident Response:** Enriching security logs and responding to threats proactively.
   - **Security Research:** Studying brute-force techniques and attacker behavior.
   - **IP Reputation Analysis:** Reporting malicious IPs to services like AbuseIPDB to improve global cybersecurity.

## **Accessing the Honeypot After Disabling SSH**  

- Since SSH has been **completely disabled** on the honeypot to act solely as a decoy, **remote access** is only possible through Azure's **Serial Console**.  

- #### **What is the Serial Console?**  
   - The Azure Serial Console provides direct access to the virtual machine's **serial port**, allowing you to manage and troubleshoot the system **without requiring SSH access**. This is useful for debugging, configuring services, and recovering access to the system.  

- #### **To use the Serial Console, you must first enable Boot Diagnostics:**  

1. **Go to the Azure Portal**  
2. Navigate to your **Virtual Machine**  
3. Click on **Boot Diagnostics** (under Support + Troubleshooting)  
4. Click **Enable** and ensure a **Storage Account** is selected  
5. Save the settings  
   <img src="assets/7-Serial Console.png" alt="Step 7 - Serial Console" width="500">

- Once Boot Diagnostics is enabled, you can:  
   - Open the **Serial Console** from the VM's Overview page in Azure  
   - Interact with the system as if you were physically connected to the machine  

- This method ensures that even with **SSH disabled**, you still have a way to access and manage the honeypot. 🚀

## **Limitations and Constraints**

- Due to an issue verifying my **Egyptian phone number**, I couldn't create a standard Azure account. As a result, I had to use the **Microsoft Azure Learn Sandbox**, which comes with certain limitations, such as restricted resource availability and temporary environments that auto-expire.

## **Contributing**

- Contributions are welcome! If you have suggestions or improvements, feel free to open a pull request or issue on the repository.

## **License**

- This project is released under the **MIT License**.

