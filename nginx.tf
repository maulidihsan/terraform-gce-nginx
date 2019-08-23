resource "google_compute_instance" "nginx-maulid" {
  count        = length(var.nginx_names[local.env])
  name         = element(var.nginx_names[local.env], count.index)
  zone         = var.nginx_zone
  machine_type = element(var.nginx_specs[local.env], count.index)

  network_interface {
    subnetwork         = google_compute_subnetwork.network-app-maulid.self_link
    subnetwork_project = var.subnetwork_project

    access_config {

    }
  }

  boot_disk {
    initialize_params {
      size  = var.nginx_boot_size
      type  = var.nginx_disk_type
      image = var.nginx_image
    }
  }
}

locals {
  env = terraform.workspace
}

variable "nginx_names" {
  default = {
	"qa" = ["nginx-server-maulid-qa-0", "nginx-server-maulid-qa-1"]
	"dev" = ["nginx-server-maulid-dev-0"]
	"prod" = ["nginx-server-maulid-prod-0", "nginx-server-maulid-prod-1", "nginx-server-maulid-prod-2"]
  }
}

variable "nginx_zone" {
  default = "asia-southeast1-a"
}

variable "nginx_specs" {
  default = {
	"qa" = ["custom-2-4096", "custom-2-4096"]
	"dev" = ["custom-1-1024"]
	"prod" = ["custom-4-8192", "custom-4-8192", "custom-4-8192"]	
  }
}

variable "nginx_boot_size" {
  default = "20"
}

variable "nginx_disk_type" {
  default = "pd-standard"
}

variable "nginx_image" {
  default = "centos-7-v20190813"
}

variable "subnetwork_project" {
  default = "infra-lab-224809"
}
