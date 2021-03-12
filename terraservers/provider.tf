terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "1.22.2"
        }
    }
}

variable "DIGOCTOKEN" {}
variable "MY_KEY" {}

provider "digitalocean" {
    token = var.DIGOCTOKEN
}

data "digitalocean_ssh_key" "terraform" {
    name = "terraform"
}
