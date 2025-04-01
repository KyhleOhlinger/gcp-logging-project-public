# #########################################################################
# ## Google Project Definitions
# #########################################################################
resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.resource_prefix}-"
}

resource "google_project" "terraform_project" {
  name            = var.resource_prefix
  project_id      = random_id.id.hex
  org_id          = var.organization_id  
  billing_account = var.billing_account  
  deletion_policy = "DELETE"
} 

#########################################################################
## Google Services Definitions
#########################################################################
resource "google_project_service" "gcp_services" {
  for_each                    = toset(var.gcp_service_list)
  project                     = google_project.terraform_project.project_id 
  service                     = each.key
  disable_dependent_services  = true
  disable_on_destroy          = true
  depends_on = [google_project.terraform_project]

  timeouts {
    create = "30m"
    update = "40m"
  }
}

# #########################################################################
# ## Calling Modules
# #########################################################################
module "gcp_core_logging" {
  source      = "./modules/logging"
  depends_on  = [google_project.terraform_project, google_project_service.gcp_services]

  # Passing variables to module
  project_id        = google_project.terraform_project.project_id
  region            = var.region  
  resource_prefix   = var.resource_prefix
  storage_class     = var.storage_class
  force_destroy     = var.force_destroy
  logging_bucket    = var.logging_bucket
  tf_state_bucket   = var.tf_state_bucket
  admin_project_id  = var.admin_project_id
  organization_id   = var.organization_id
}
 
module "gcp_core_billing" {
  source      = "./modules/billing"
  depends_on  = [google_project.terraform_project, google_project_service.gcp_services]

  # Passing variables to module
  project_id             = google_project.terraform_project.project_id
  resource_prefix        = var.resource_prefix
  billing_email_address  = var.billing_email_address
  billing_account        = var.billing_account
  billing_currency       = var.billing_currency
}