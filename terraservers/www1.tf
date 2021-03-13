resource "digitalocean_droplet" "www1" {
    image = "ubuntu-20-04-x64"
    name = "server1"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
    ]
    connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.MY_KEY)
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install apache
      "sudo apt-get update",
      "sudo apt-get -y install apache2 git vim python3-pip python3-venv"
    ]
  }