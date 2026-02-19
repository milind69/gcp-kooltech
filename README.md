# GCP KoolTech Terraform Project

## Overview

This Terraform project provisions Google Cloud Platform (GCP) infrastructure for the KoolTech organization. It sets up a new GCP project with associated service accounts and IAM permissions under a designated organizational folder.

## Architecture

The configuration creates the following resources:

```
Organization
└── Folder (hostdzone)
    └── Project (mpk-project)
        ├── Service Account (mpkprojectsa)
        └── IAM Role Binding (Editor role)
```

## Resources Created

### 1. Google Folder
- **Resource**: `google_folder.shared`
- **Display Name**: `hostdzone`
- **Parent**: Created under the specified organization ID
- **Purpose**: Organizational container for grouping related projects

### 2. Google Project
- **Resource**: `google_project.myproject`
- **Project ID**: `mpk-project-id`
- **Display Name**: `mpk-project`
- **Parent**: Nested within the hostdzone folder
- **Billing**: Associated with the specified billing account
- **Labels**: Tagged with `provision: terraform` for tracking

### 3. Service Account
- **Resource**: `google_service_account.mpkprojectsa`
- **Account ID**: `mpkprojectsa`
- **Display Name**: `mpkprojectsa`
- **Purpose**: Provides a principal identity for applications and services

### 4. IAM Role Binding
- **Resource**: `google_project_iam_member.mpkproject-editor`
- **Role**: `roles/editor`
- **Member**: Service account (`mpkprojectsa`)
- **Scope**: Project-level permissions

## Data Sources

The configuration fetches information about:

1. **Google Project** (`data.google_project.kooltech`)
   - Retrieves details about the specified project
   
2. **Google Organizations** (`data.google_organizations.organizations`)
   - Queries organizations by domain name
   - Used for organization validation and reference

## Input Variables

| Variable | Type | Description | Required |
|----------|------|-------------|----------|
| `project_id` | string | GCP Project ID | Yes |
| `billing_account` | string | GCP Billing Account ID | Yes |
| `org_id` | string | GCP Organization ID | Yes |
| `domain_id` | string | Domain name for organization lookup | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `org_info` | Details about the organizations matching the specified domain |

## Provider Configuration

- **Provider**: Google Cloud Platform
- **Required Version**: >= 7.18.0
- **Provider Alias**: `boss`
- **Region**: `us-central1`
- **Zone**: `us-central1-c`
- **Authentication**: Uses GCP credentials configured in your environment

## Prerequisites

1. **GCP Setup**:
   - Active GCP account with billing enabled
   - Organization created in GCP Console
   - Billing account configured

2. **Authentication**:
   - GCP credentials configured (via Application Default Credentials, service account key, or gcloud authentication)
   - Sufficient IAM permissions to create folders, projects, and service accounts

3. **Terraform**:
   - Terraform >= 1.0
   - Google provider >= 7.18.0

## Usage

### 1. Prepare Terraform Variables

Create a `terraform.tfvars` file with your values:

```hcl
project_id     = "your-project-id"
billing_account = "your-billing-account-id"
org_id          = "your-organization-id"
domain_id       = "your.domain.com"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan Deployment

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

### 5. View Outputs

```bash
terraform output
```

## File Structure

```
├── provider.tf          # GCP provider configuration
├── main.tf             # Primary resource definitions
├── variables.tf        # Input variable declarations
├── output.tf           # Output value definitions
├── data.tf             # Data source queries
├── terraform.tfvars    # Input variable values (not in version control)
├── terraform.tfstate   # State file (managed by Terraform)
└── README.md           # This file
```

## State Management

- **State File**: `terraform.tfstate`
- **Backup**: `terraform.tfstate.backup`
- **Recommendation**: Use remote state storage (Google Cloud Storage, Terraform Cloud) for production environments

## Important Notes

1. **Service Account Permissions**: The created service account has Editor role at the project level. Consider restricting this to specific roles based on your security requirements.

2. **Cost Implications**: Creating a project with an active billing account will incur GCP charges. Ensure proper budget alerts are configured.

3. **State Management**: Never commit `terraform.tfstate` or `terraform.tfstate.backup` to version control. Use a remote backend for team collaboration.

4. **Zone Configuration**: The provider is configured for `us-central1` region and `us-central1-c` zone. Modify as needed.

## Troubleshooting

### Authentication Errors
Ensure GCP credentials are properly configured:
```bash
gcloud auth application-default login
```

### Permission Denied
Verify your GCP account has necessary permissions in the organization:
- Folder Creator
- Project Creator
- Service Account Admin

### Variable Issues
Ensure all required variables are provided in `terraform.tfvars` or via command line:
```bash
terraform apply -var="project_id=xxx" -var="billing_account=yyy"
```

## References

- [Terraform Google Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started)
- [GCP Organization Best Practices](https://cloud.google.com/docs/enterprise/setup-checklist)

## License

[Specify your license here]

## Contact

For questions or issues, please reach out to the infrastructure team.
