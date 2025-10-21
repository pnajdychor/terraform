resource "digitalocean_droplet" "name" {
  image  = "ubuntu-22-04-x64"
  name   = "example"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  backups = false
  ssh_keys = [digitalocean_ssh_key.public_key.id]
  vpc_uuid = digitalocean_vpc.vpc02.id
  #created_at = "2024-06-01T12:00:00Z"
}

resource "digitalocean_ssh_key" "public_key"{
    name = "example_key_pk"
    public_key = tls_private_key.name.public_key_openssh
}

resource "tls_private_key" "name" {
    algorithm = "ED25519"
  
}

resource "digitalocean_project" "projekt02" {
  name        = "zadanie02"
  description = "A project to represent development resources."
  purpose     = "Web Application"
  environment = "Development"
  resources   = [digitalocean_droplet.name.urn]
}

resource "digitalocean_vpc" "vpc02" {
  name   = "zadanie02vpc"
  region = "nyc3"
}

resource "digitalocean_firewall" "web02" {
  name = "only-02"

  droplet_ids = [digitalocean_droplet.name.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["157.230.116.2"]
  }

    outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}