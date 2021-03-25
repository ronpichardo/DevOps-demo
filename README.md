# DevOps-demo
Demo project for creating a simple and basic automated workflow

## Overview
Creating a simple Python & HTML app, setup to be watched by Jenkins and Deploy any updates to some web servers running Apache

This demo was created using the following tools:
1. Terraform to create 3 Ubuntu Servers running Apache
2. Digital Ocean was used as the provider for Terraform
3. Docker to create a container that runs Jenkin
4. Jenkins to monitor this Repo for change
5. Ansible within Jenkins to deploy the updated HTML file to the 3 Ubuntu Servers

TODO:
- How to create a SSH Key Pair for Terraform/Ansible to use for connecting to DigitalOcean servers
- How to setup local machine filepaths for Docker
- How to share the local SSH Key with the Jenkins Container
 
## Prerequisites

1. To complete this tutorial, you’ll need start with a DigitalOcean account:

    - A DigitalOcean account. If you do not have one, sign up for a new account at https://cloud.digitalocean.com/registrations/new
    - A DigitalOcean Personal Access Token, which you can create via the DigitalOcean control panel. Instructions to do that can be found in this link: https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken
    - A password-less SSH key added to your DigitalOcean account(we'll need this for Ansible and Jenkins), which you can do by following this link(reminder when you add the key, name it terraform as that is how it is configured in the Terraform files): https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets

2. Setting up Terraform for DigitalOcean
    Below are the sequence of commands to run for configuring the DigitalOcean platform as a provider.
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

3. Docker installed on your computer or Virtual Environment (I have Docker running on a Debian instance on a Proxmox virtualization server)

    - Docker(Links for installing in Windows/MacOS/Linux) - https://docs.docker.com/get-docker/
    ![image](https://user-images.githubusercontent.com/63974878/110734474-e5f5e480-81f5-11eb-8d26-901194df3e01.png)

    - Docker-Compose - https://docs.docker.com/compose/install/
    ![image](https://user-images.githubusercontent.com/63974878/110734570-15a4ec80-81f6-11eb-9066-856abec5211f.png)

4. Jenkins is also required as the CI/CD tool that will be used to monitor your Git Repo.  To avoid building a new Virtual Machine in Proxmox, I installed Jenkins as a Docker Container.

    - On the VM running Docker, create a file path to map to Jenkins in Docker(I created a folder on root in the Debian server named `dockerdata` and then a folder inside `dockerdata` named `jenkins` for ease of use).
    Once the path is created, you can run the following command
    ```shell
    $ sudo mkdir -p /dockerdata/jenkins
    $ docker run -d -p 8080:8080 -v /dockerdata/jenkins:/var/jenkins_home --name jenkins-demo jenkins/jenkins:lts
    $ cp .ssh/id_rsa /dockerdata/jenkins/jenkins_home/
    ```
    - Install Ansible inside of the Docker container, first we connect to a interactive bash terminal using `exec -it` command on the running Jenkins Container, and then install Ansible
    ```shell
    $ docker exec -it jenkins-demo bash
    jenkins-demo# echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' >> /etc/apt/source.list
    jenkins-demo# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
    jenkins-demo# sudo apt-get update
    jenkins-demo# sudo apt-get install -y ansible
    ```

5. Configure Ansible to deploy from the Jenkins container to the 3 webservers once a change is made on the Git Repo
    - Once you have the 3 webserver IP addresses from the terraform results, we add them to the `/etc/ansible/hosts` file, and also map the sshkey that we copied into the container from the previous steps
    ```shell
    [webservers]
    1.1.1.1
    2.2.2.2
    3.3.3.3

    [webservers:vars]
    ansible_user=root
    ansible_ssh_private_key_file=/var/jenkins_home/dosshkey
    ```
## Installation
```shell
$ git clone https://github.com/ronpichardo/DevOps-demo.git
$ cd DevOps-demo
$ python3 -m venv venv
$ source venv/bin/activate
$ pip -r install requirements.txt
$ python app.py
```

