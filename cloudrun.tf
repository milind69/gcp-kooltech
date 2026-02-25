resource "google_artifact_registry_repository" "my-repo" {
  location = "us-central1"
  repository_id = "my-repository"
  description = "example docker repository"
  format = "DOCKER"
}



# resource "google_cloud_run_v2_service" "my-fastapi-app" {
#   name     = "${var.app_name}-app"
#   location = "us-central1"
#   deletion_protection = false
#   #ingress = "INGRESS_TRAFFIC_ALL"
#   ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
#   template {
#       containers {
#         name  = "${var.app_name}"
#         image = "${var.region}-docker.pkg.dev/${google_project.myproject.project_id}/${google_artifact_registry_repository.my-repo.repository_id}/my-fastapi-app:latest"

#         ports {
#           container_port = 8000
#         }

#         resources {
#           limits = {
#             cpu    = "1"
#             memory = "512Mi"
#           }
#         }
#       }
#       scaling {
#         min_instance_count = 0
#         max_instance_count = 2
#       }
#   }
# }



resource "google_service_account" "apigee-cloud-runnersa" {
  account_id = "apigee-cloud-runnersa"
  display_name = "Apigee cloud runner"
  project = google_project.myproject.project_id
}


# To grant this access you need to grant the terraform id a orgpolicy role 

# gcloud organizations add-iam-policy-binding 1069851491353 \
#   --member="user:terraformid@org.com" \
# --role="roles/orgpolicy.policyAdmin"

# resource "google_cloud_run_v2_service_iam_member" "my-fastapi-app-apigee-cloud-runner" {
#   name = google_cloud_run_v2_service.my-fastapi-app.name
#   location = "${var.region}"
#   project = google_project.myproject.project_id
#   role    = "roles/run.invoker"
#   member  = "serviceAccount:${google_service_account.apigee-cloud-runnersa.email}"
# }   


# resource "google_cloud_run_v2_service_iam_member" "my-fastapi-app-anonymous" {
#   name = google_cloud_run_v2_service.my-fastapi-app.name
#   location = "${var.region}"
#   project = google_project.myproject.project_id
#   role    = "roles/run.invoker"
#   member  = "user:milind@kooltech.xyz"
# }   


# # to use extenal account 
# resource "google_cloud_run_v2_service_iam_member" "my-fastapi-app-external-viewer" {
#   name = google_cloud_run_v2_service.my-fastapi-app.name
#   location = "${var.region}"
#   project = google_project.myproject.project_id
#   role    = "roles/run.viewer"
#   member  = "user:kulkarni.milind@gmail.com"
# }  

# resource "google_cloud_run_v2_service_iam_member" "my-fastapi-app-external" {
#   name = google_cloud_run_v2_service.my-fastapi-app.name
#   location = "${var.region}"
#   project = google_project.myproject.project_id
#   role    = "roles/run.invoker"
#   member  = "user:kulkarni.milind@gmail.com"
# }  

# # testing using curl
# # curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
# #   https://your-cloud-run-url/docs

# # To tesing via browser Proxy
# # gcloud run services proxy my-fastapi-app-app \
# #   --region=us-central1 \
# #   --project=$(gcloud config get project) \
# #   --port=8080
