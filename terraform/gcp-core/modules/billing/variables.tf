#########################################################################
## Project Defaults Definitions
#########################################################################
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

variable "resource_prefix" {
  type        = string
  description = "Prefix for GCP Logging Project Resources"
  default     = ""
}

variable "project_id" {
  type        = string
  description = "Project ID"
  default     = ""
}