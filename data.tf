
data "google_project" "kooltech" {
    project_id = "${var.project_id}"
    provider = google.boss
}

data "google_organizations" "organizations" {
    filter = "domain:${var.domain_id}"
    provider = google.boss
}

