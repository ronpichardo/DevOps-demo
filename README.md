# DevOps-demo
Demo project for creating a simple and basic automated workflow

## Overview
Creating a simple Python & HTML app, setup to be watched by Jenkins and Deploy updates to some web servers running Apache

This demo was created using the following tools:
1. Terraform to create 3 Ubuntu Servers running Apache, Digital Ocean was used as the provider for Terraform
2. Docker to create a container that runs Jenkin
3. Jenkins to monitor this Repo for change
4. Ansible within Jenkins to deploy the updated HTML file to the 3 Ubuntu Servers

TODO:
- How to create a SSH Key Pair for Terraform/Ansible to use for connecting to DigitalOcean servers
- How to setup local machine filepaths for Docker
- How to share the local SSH Key with the Jenkins Container
 
## Installation
```shell
$ git clone https://github.com/ronpichardo/DevOps-demo.git
$ cd DevOps-demo
$ python3 -m venv venv
$ source venv/bin/activate
$ pip -r install requirements.txt
$ python app.py
```

Setting up Terraform for DigitalOcean
Below are the sequence of commands to run for configuring the DigitalOcean platform as a provider\n
If you do not run into any errors, your last terraform command will ask you if you want to proceed, enter in "yes"

Once the deployment is complete, you can type `terraform show terraform.tfstate` to get the ipv4 addresses from the servers that are now running with Apache.

Before proceeding to following the commands, you will need to sign into DigitalOcean and get an API to replace the `TOKEN_FROM_DO_API` value.

```shell
export DOTOKEN="TOKEN_FROM_DO_API"
cd terraservers
terraform init
terraform plan -var "DIGOCTOKEN=${DOTOKEN}" -var "MY_KEY=$HOME/.ssh/id_rsa"
terraform apply -var "DIGOCTOKEN=${DOTOKEN}" -var "MY_KEY=$HOME/.ssh/id_rsa"
```

