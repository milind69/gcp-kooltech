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
#   ingress = "INGRESS_TRAFFIC_ALL"
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

# grant anonymous permission
# resource "google_cloud_run_v2_service_iam_member" "my-fastapi-app-anonymous" {
#   name = google_cloud_run_v2_service.my-fastapi-app.name
#   location = "${var.region}"
#   project = google_project.myproject.project_id
#   role    = "roles/run.invoker"
#   member  = "user:xxxx@mail.comß"
# }   