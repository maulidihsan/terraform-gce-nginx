resource "google_compute_instance_group" "nginx-servers-maulid" {
	name = "nginx-servers-maulid"
	
	instances = [
	  google_compute_instance.nginx-maulid.0.self_link,
	  google_compute_instance.nginx-maulid.1.self_link,
	  google_compute_instance.nginx-maulid.2.self_link
	]

	named_port {
	  name = "http"
	  port = "80"
	}

	zone = "asia-southeast1-a"
}

resource "google_compute_http_health_check" "check-nginx-maulid" {
	name = "check-nginx-maulid"
	request_path = "/"
}

resource "google_compute_backend_service" "nginx-service-maulid" {
	name = "nginx-service-maulid"
	port_name = "http"
	protocol = "HTTP"

	backend {
	  group = google_compute_instance_group.nginx-servers-maulid.self_link
	}

	health_checks = [
	  google_compute_http_health_check.check-nginx-maulid.self_link
	]
}

resource "google_compute_url_map" "nginx-urlmap-maulid" {
	name = "nginx-urlmap-maulid"
	default_service = google_compute_backend_service.nginx-service-maulid.self_link

	host_rule {
	  hosts = ["blibli-maulid.com"]
	  path_matcher = "maulidpath"
	}

	path_matcher {
	  name = "maulidpath"
	  default_service = google_compute_backend_service.nginx-service-maulid.self_link
	  
	  path_rule {
	    paths = ["/*"]
	    service = google_compute_backend_service.nginx-service-maulid.self_link
	  }
	}
}

resource "google_compute_target_http_proxy" "nginx-http-proxy-maulid" {
	name = "nginx-http-proxy-maulid"
	url_map = google_compute_url_map.nginx-urlmap-maulid.self_link
}

resource "google_compute_global_forwarding_rule" "nginx-forward-rule-maulid" {
	name  = "nginx-forward-rule-maulid"
	target = google_compute_target_http_proxy.nginx-http-proxy-maulid.self_link
	port_range = "80"
}
