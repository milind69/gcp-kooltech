
# Top-level folder under an organization.
resource "google_folder" "shared" {
  display_name = "hostdzone"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "myproject" {
  name       = "mpk-project"
  project_id = "mpk-project-id"
  billing_account = "${var.billing_account}"
  folder_id = google_folder.shared.id
  labels = {
    "provision" = "terraform"
  }
}


# gcloud organizations add-iam-policy-binding <orgid> \
#   --member="user:appuserrunninggtf" \
# --role="roles/orgpolicy.policyAdmin"


resource "google_project_organization_policy" "allow_all_members" {
  project    = "mpk-project-id"
  depends_on = [ google_project.myproject ]
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      all = true
    }
  }
}

resource "google_project_service" "apis" {
  project = google_project.myproject.project_id
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "apigee.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "container.googleapis.com",
  ])
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "mpkprojectsa" {
  account_id = "mpkprojectsa"
  display_name = "mpkprojectsa"
  project = google_project.myproject.project_id
}


resource "google_project_iam_member" "mpkproject-editor" {
  project = google_project.myproject.project_id
  role = "roles/editor"
  member = "serviceAccount:${google_service_account.mpkprojectsa.email}"
}


resource "google_compute_network" "vpc" {
  name = "vpc-network"
  project = google_project.myproject.project_id
  auto_create_subnetworks = false 
  depends_on = [ google_project_service.apis ]
}

resource "google_compute_subnetwork" "app_subnet" {
  name = "${var.app_name}-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  region = "us-central1"
  network = google_compute_network.vpc.id
  project = google_project.myproject.project_id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "psc_nat" {
  name = "${var.app_name}-psc-nat-subnet"
  ip_cidr_range = "${var.psc_nat_subnet_cidr}"
  region = "us-central1"
  network = google_compute_network.vpc.id
  project = google_project.myproject.project_id
  purpose = "PRIVATE_SERVICE_CONNECT"
}

resource "google_compute_global_address" "apigee_range" {
  name          = "${var.app_name}-apigee-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 22
  address       = split("/", var.apigee_cidr)[0]
  network       = google_compute_network.vpc.id
}


