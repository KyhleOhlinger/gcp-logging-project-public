#########################################################################
## Project Defaults Definitions
#########################################################################
variable "region" {
  type        = string
  description = "Default Region"
  default     = "us-east1"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix for GCP Logging Project Resources"
  default     = ""
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

variable "admin_project_id" {
  type        = string
  description = "Admin Project ID"
  default     = ""
}

variable "organization_id" {
  type        = string
  description = "Organization ID"
  default     = ""
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
  default     = ""
}

variable "logging_bucket" {
  type        = string
  default     = ""
}