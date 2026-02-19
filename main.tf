# resource "google_compute_network" "vpc_network" {
#   name = "vpc-network"
# }

# Top-level folder under an organization.



# Top-level folder under an organization.
resource "google_folder" "shared" {
  display_name = "hostdzone"
  parent       = "organizations/${var.org_id}"
  provider = google.boss
}

resource "google_project" "myproject" {
  name       = "mpk-project"
  project_id = "mpk-project-id"
  billing_account = "${var.billing_account}"
  folder_id = google_folder.shared.id
  provider = google.boss
  labels = {
    "provision" = "terraform"
  }
}

resource "google_service_account" "mpkprojectsa" {
  account_id = "mpkprojectsa"
  display_name = "mpkprojectsa"
  project = google_project.myproject.project_id
  provider = google.boss
}


resource "google_project_iam_member" "mpkproject-editor" {
  project = google_project.myproject.project_id
  role = "roles/editor"
  member = "serviceAccount:${google_service_account.mpkprojectsa.email}"
  provider = google.boss
}


