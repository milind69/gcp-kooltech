
# output "project_name" {
#   value = data.google_project.project
# }

# output "project_number" {
#   value = data.google_project.project.number  

# }

output "org_info" {
  value = data.google_organizations.organizations
}

# output "apigee" {
#   value = google_apigee_organization.apigee_org
# }