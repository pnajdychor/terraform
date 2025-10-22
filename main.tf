resource "digitalocean_project" "this" {
  name        = var.name
  description = "A project to represent development resources. "
  purpose     = "Web Application"
  environment = "Development"
  resources   = [digitalocean_droplet.this.urn]
}

resource "digitalocean_vpc" "vpc02" {
  name   = var.name
  region = var.region
  ip_range = var.subnet
}

resource "digitalocean_droplet" "this" {
  image  = "ubuntu-22-04-x64"
  name   = var.name
  region = var.region
  size   = "s-1vcpu-1gb"
  backups = false
  ssh_keys = [digitalocean_ssh_key.public_key.id]
  vpc_uuid = digitalocean_vpc.vpc02.id
  #created_at = "2024-06-01T12:00:00Z"
}

resource "digitalocean_ssh_key" "public_key"{
    name = var.name
    public_key = tls_private_key.this.public_key_openssh
}

resource "tls_private_key" "this" {
    algorithm = "ED25519"
  
}

resource "digitalocean_firewall" "web02" {
  name = var.name

  droplet_ids = [digitalocean_droplet.this.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["157.230.116.2/32"]
  }

    outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}

resource "local_file" "this" {
  filename = "${path.root}/id_ed25519"
  file_permission = "0600"
  content = tls_private_key.this.private_key_openssh
}