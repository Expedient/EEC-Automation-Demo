locals {
  wordpress_app_ip = "IP address"
  wordpress_db_ip  = "IP address"
  local_wp_app_ip = "IP address"
  local_wp_db_ip = "IP address"
}


provider "vcd" {
  user                 = "${var.vcd_user}"
  password             = "${var.vcd_pass}"
  org                  = "${var.vcd_org}"                  # Default for resources
  vdc                  = "${var.vcd_vdc}"                  # Default for resources
  url                  = "${var.vcd_url}"
  max_retry_timeout    = "${var.vcd_max_retry_timeout}"
  allow_unverified_ssl = true
}

resource "vcd_vapp" "wordpress_app" {
  name = "wordpress_app"
}

resource "vcd_vapp" "wordpress_db" {
  name = "wordpress_db"
}

resource "vcd_vapp_vm" "wordpress_app" {
  vapp_name       = "wordpress_app"
  name            = "wordpress-app"
  catalog_name    = "CatalogName"
  template_name   = "ubuntu-16.04"
  memory          = 4096
  cpus            = 2
  cpu_cores       = 1

  initscript = "echo nameserver 8.8.8.8 >> /etc/resolvconf/resolv.conf.d/tail && echo ssh-rsa PUBLICKEY >> /home/ubuntu/.ssh/authorized_keys"


  metadata = {
    role = "app"
  }

  network {
    type               = "org"
    name               = "EEC-Demo-Network"
    ip_allocation_mode = "MANUAL"
    ip                 = "${local.local_wp_app_ip}"
    is_primary         = true
  }


  depends_on = ["vcd_vapp.wordpress_app"]
}

resource "vcd_vapp_vm" "wordpress_db" {
  vapp_name         = "wordpress_db"
  name              = "wordpress-db"
  catalog_name      = "CatalogName"
  template_name     = "ubuntu-16.04"
  memory            = 4096
  cpus              = 2
  cpu_cores         = 1

  initscript = "echo nameserver 8.8.8.8 >> /etc/resolvconf/resolv.conf.d/tail && echo ssh-rsa PUBLICKEY >> /home/ubuntu/.ssh/authorized_keys"

  metadata = {
    role = "db"
  }

  network {
    type               = "org"
    name               = "EEC-Demo-Network"
    ip_allocation_mode = "MANUAL"
    ip                 = "${local.local_wp_db_ip}"
    is_primary         = true
  }


  depends_on = ["vcd_vapp.wordpress_db"]
}

output "wordpress_db_address" {
  value = local.wordpress_db_ip
}

output "wordpress_db_private_address" {
  value = vcd_vapp_vm.wordpress_db.network[0].ip
}

output "wordpress_app_address" {
  value = local.wordpress_app_ip
}

output "wordpress_local_app_address" {
  value = local.local_wp_app_ip
}

output "wordpress_local_db_address" {
  value = local.local_wp_db_ip
}