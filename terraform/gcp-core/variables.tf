#########################################################################
## Project Defaults Definitions
#########################################################################
variable "organization_id" {
  type        = string
  description = "Organization ID"
  default     = ""
}

variable "billing_account" {
  type        = string
  description = "Billing Account ID"
  default     = ""
}

variable "billing_email_address" {
  type        = string
  description = "Main Billing Email Address"
  default     = ""
}

variable "billing_currency" {
  type        = string
  description = "Account Billing Currency"
  default     = "CAD"
}

variable "admin_project_id" {
  type        = string
  description = "Admin Project ID"
  default     = ""
}

variable "region" {
  type        = string
  description = "Default Region"
  default     = "us-east1"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for GCP Logging Project Resources"
  default     = "gcp-logging"
}

variable "force_destroy" {
  type        = bool
  description = "Default value for destruction of resources"
  default     = true

}

variable "project_id" {
  type        = string
  description = "Project ID"
  default     = ""
}

# #########################################################################
# ## Google Services Definitions
# #########################################################################
variable "gcp_service_list" {
  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "logging.googleapis.com",
    "billingbudgets.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com"
  ]
}

#########################################################################
## Google Storage Definitions
#########################################################################
variable "storage_class" {
  type        = string
  description = "Default Bucket storage class"
  default     = "STANDARD"
}

variable "tf_state_bucket" {
  type        = string
  default     = "gcp-logging-project-tfstate"
}

variable "logging_bucket" {
  type        = string
  default     = "centralized-logs"
}