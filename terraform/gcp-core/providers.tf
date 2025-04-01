provider "google" {
  project = var.admin_project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "gcp-logging-project-tfstate"
    prefix = "terraform/state"
  }
} 