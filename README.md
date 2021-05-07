# DevOps-project

This project was created as a task made by Scalac DevOps team :)

It can be divided into 3 parts:

 - terraform initialising an infrastructure in AWS cloud for prepared service,

 - ansible provisioning VM and preparing dockerized Jenkins CasC server,

 - Jenkins, upon finished provisioning, clones the repo and executes CI pipline described in Jenkinsfile.

## Requirements

- to run the environment, AWS credentials must be present for the running shell - either as saved in environment or saved with aws cli.
- EC2 VM requires ssh-key pair for availability. The private and public keys should be put into ~/.ssh directory of local user and paths should be replaced in `terraform/variables.tf` file.
- local machine must also have installed Ansible community.docker module.

##### Terraform

As the infrastructure consists of single VM and it's necessary components, rather than dividing it into mutiple files it was put together in single file - `terraform/main.tf`.
Additionally, in `terraform/variables.tf` part of variables used in main.tf has been declared. 

After initialisation, Jenkins instance public ip address and port will be printed to stdout.

##### Ansible

Upon finishing initialisation, Terraform will invoke ansible role to update and provision the EC2 VM with dockerized Jenkins server with its configuration files.

If the path to private key was specified earlier as suggested, everything should go well.

TODO:
- parametrise the ansible playbooks - some variables were left in playbooks whereas these should be put into var files to make playbooks more immutable. 

If time allows for that, it will be fixed soon.

##### Serivce run on Jenkins 

The service which is build by Jenkins is working - it is capable of printing 100 latest jokes from bash.org.pl site.
Unfortunatelly, due to time constrains and lack of expirience in working with Jenkins, as of now pipeline is not fully prepared and it may fail.

TODO:
- prepare unit test for the 100-jokes-service,
- add code checking steps - at least lint/flake tests,
- save the service docker image as artifact into archive.

##### USAGE

Clone repository: `git clone https://github.com/rpiecyk/DevOps-project.git`

Prepare ssh key pair. Note it system paths and replace variables *instance_key* (public key) and *private_key* in `terraform/variables.tf`

In *terraform* dir: `cd DevOps-project/terraform` (BTW, sorry for creative name ^^") run terraform init, plan and apply:

`terraform init`

`terraform plan`

`terraform apply`


in the catalogue `ansible/roles/build_jenkins/files/secret/` thare is a file named `admin`. In this file we can define a password for `admin` user in Jenkins.
Feel free to leave the one described there but it is not secure :-)

That's about it. If you have any questions or suggestions feel free to mention it!
