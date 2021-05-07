# DevOps-project

This project was created as a task made by Scalac DevOps team :)

It can be divided into 3 parts:

 - terraform initialising an infrastructure in AWS cloud for prepared service,

 - ansible provisioning VM and preparing dockerized Jenkins CasC server,

 - Jenkins upon finished provisioning clones the repo and executes CI pipline described in Jenkinsfile.

## Requirements

- to run the environment, AWS credentials must be present for the running shell - either as saved in environment or saved with aws cli.
- EC2 VM requires ssh-key pair for availability. The private key should be put into ~/.ssh directory of local user and his path should be replaced in `terraform/variables.tf` file.
- local machine must also have installed Ansible community.docker module.

##### Terraform

As the infrastructure consists of single VM and it's necessary components, rather than dividing it into mutiple files it was put together in single file - `terraform/main.tf`.
Additionally, in `terraform/variables.tf`. 
After initialisation, VM public ip address will be printed.

##### Ansible

Upon finishing initialisation, Terraform will invoke ansible role to provision the EC2 VM with dockerized Jenkins server with its configuration files.
If the path to private key was specified earlier as suggested, everything should go well.

TODO:
- parametrise the ansible playbooks - some variables were left in playbooks whereas these should be put into var files to make playbooks more immutable.

##### Serivce run on Jenkins 

The service which is build by Jenkins is working - it is capable of printing 100 latest jokes from bash.org.pl site.
Unfortunatelly, due to time constrains and lack of expirience in working with Jenkins, as of now pipeline is not fully prepared and it

TODO:
- prepare unit test for the service,
- add code checking steps - at least lint/flake tests,
- save the service docker image as artifact into archive.

##### USAGE

Clone repository: `git clone https://github.com/rpiecyk/DevOps-project.git`

Prepare ssh key pair. Note it system paths and replace variables *instance_key* (public key) and *private_key* in `terraform/variables.tf`

In *terraform* dir: `cd DevOps-project/terraform` (BTW, sorry for creative name ^^") run terraform init, plan and apply:

`terraform init`
`terraform plan`
`terraform apply`





