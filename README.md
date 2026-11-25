\# Drupal High Availability Project



\## Project Overview



This project demonstrates the deployment and configuration of a Drupal application on AWS using Infrastructure as Code, configuration management, and monitoring tools.



Terraform was used to provision the AWS infrastructure, while Ansible automated the Drupal installation and configuration.



\## Architecture



The project infrastructure included:



\- Amazon VPC with public and private subnets across two Availability Zones.

\- Application Load Balancer (ALB) to distribute incoming HTTP traffic.

\- EC2 application servers managed by an Auto Scaling Group.

\- Amazon RDS MySQL database in private subnets.

\- NAT Gateways for outbound internet access from private subnets.

\- AWS Systems Manager for instance management.

\- Private Amazon S3 bucket for Ansible file transfers.



\## Technologies Used



\- AWS

\- Terraform

\- Ansible

\- Ubuntu Server

\- Drupal

\- Apache

\- PHP

\- MySQL / Amazon RDS

\- Docker Compose

\- Prometheus

\- Grafana

\- Git and GitHub



\## Screenshots



\### Drupal Website

!\[Drupal Website](screenshots/drupal-website.png)



\### Application Load Balancer

!\[ALB Healthy Targets](screenshots/alb-healthy-targets.png)



\### Auto Scaling Instances

!\[Auto Scaling Instances](screenshots/autoscaling-instances.png)



\### RDS Database

!\[RDS Database](screenshots/rds-available.png)



\### Ansible Deployment

!\[Ansible Deployment](screenshots/ansible-deployment.png)



\### Prometheus Dashboard

!\[Prometheus Dashboard](screenshots/prometheus-dashboard.png)



\### Grafana Dashboard

!\[Grafana Dashboard](screenshots/grafana-dashboard.png)



\## Security Considerations



\- Database resources were placed in private subnets.

\- Database access was restricted to the application security group.

\- The S3 bucket was private.

\- AWS credentials and Terraform state files were excluded from version control.

\- Ansible prompted for sensitive passwords rather than storing them directly in playbooks.



\## Future Improvements



\- Configure shared Drupal file storage using Amazon EFS.

\- Add HTTPS using AWS Certificate Manager.

\- Extend Prometheus monitoring to cover application servers.

\- Configure persistent Grafana storage.

\- Add a GitHub Actions CI/CD workflow.

\- Configure and verify Multi-AZ database deployment.



\## Project Cleanup



The AWS infrastructure created for this project was subsequently destroyed using Terraform to avoid ongoing cloud charges.



The repository preserves the project configuration, automation files, monitoring setup, and screenshots for learning and portfolio purposes.

