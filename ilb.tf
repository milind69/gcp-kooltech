
# ## Create serverless NEG and backend service ilb

# resource "google_compute_region_network_endpoint_group" "cloudrun-neg" {
#   name         = "cloudrun-neg"
#   network_endpoint_type = "SERVERLESS"
#   region = "${var.region}"
#   project = google_project.myproject.project_id
#   cloud_run {
#     service = google_cloud_run_v2_service.my-fastapi-app.name
#   }
# }


# resource "google_compute_region_backend_service" "cloudrun_backend" {
#   name = "cloudrun-backend"
#   region = "${var.region}"
#   project = google_project.myproject.project_id
#   load_balancing_scheme = "INTERNAL_MANAGED"
#   protocol = "HTTPS"
#   backend {
#     group = google_compute_region_network_endpoint_group.cloudrun-neg.id
#   }
# }

# # Self-signed cert (replace with proper cert in prod)
# resource "google_compute_region_ssl_certificate" "cert" {
#   name        = "cloudrun-cert"
#   region      = var.region
#   private_key = tls_private_key.key.private_key_pem
#   certificate = tls_self_signed_cert.cert.cert_pem
# }

# resource "tls_private_key" "key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "tls_self_signed_cert" "cert" {
#   private_key_pem = tls_private_key.key.private_key_pem

#   subject {
#     common_name = "my-backend.internal"
#   }

#   validity_period_hours = 87600

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }



# resource "google_compute_region_url_map" "cloudrun_url_map" {
#   name = "cloudrun-url-map"
#   region = "${var.region}"
#   project = google_project.myproject.project_id
#   default_service = google_compute_region_backend_service.cloudrun_backend.id
# }

# resource "google_compute_region_target_https_proxy" "https_proxy" {
#   name = "cloudrun-https-proxy"
#   region = "${var.region}"
#   project = google_project.myproject.project_id
#   url_map = google_compute_region_url_map.cloudrun_url_map.id
#   ssl_certificates = []
  
# }


# resource "google_compute_subnetwork" "apigee_subnet" {
#   name          = "apigee-subnet"
#   region        = var.region
#   network       = google_compute_network.vpc.id
#   ip_cidr_range = "${var.apigee_subnet_cidr}"

# }
# # Forwarding rule — this becomes the PSC target
# resource "google_compute_forwarding_rule" "ilb" {
#   name                  = "cloudrun-ilb"
#   region                = var.region
#   load_balancing_scheme = "INTERNAL_MANAGED"
#   target                = google_compute_region_target_https_proxy.https_proxy.id
#   network               = google_compute_network.vpc.id
#   subnetwork            = google_compute_subnetwork.apigee_subnet.id
#   port_range            = "443"
#   allow_global_access   = true

#   # Needed for PSC
#   service_label = "cloudrun-ilb"
# }


