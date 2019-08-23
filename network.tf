resource "google_compute_network" "network-basic-maulid" {
	count = local.dev != "default" ? 0 : 1
	name = var.net_name
	auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-app-maulid" {
	name = var.subnet_name[local.env]
	ip_cidr_range = var.net_cidr[local.env]
	network = var.net_name
}

locals {
  dev = terraform.workspace
}

variable "net_cidr" {
  default = {
	"qa" = "192.168.15.0/24"
	"dev" = "192.168.8.0/24"
	"prod" = "192.168.35.0/24"
  }
}

variable "subnet_name" {
  default = {
	"qa" = "network-app-maulid-qa"
	"dev" = "network-app-maulid-dev"
	"prod" = "network-app-maulid-prod"
  }
}

variable "net_name" {
  default = "network-basic-maulid"
}
