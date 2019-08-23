resource "google_compute_firewall" "firewall-nginx-maulid" {
	name = "firewall-nginx-maulid"
	network = "network-basic-maulid"

	allow {
	  protocol = "tcp"
	  ports = ["22", "80"]
	}

	source_ranges = ["0.0.0.0/0"]
}
