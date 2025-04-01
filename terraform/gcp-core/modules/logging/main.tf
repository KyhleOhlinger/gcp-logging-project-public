
# #########################################################################
# ## Project's Logging Configuration Definition 
# #########################################################################
resource "google_project_iam_audit_config" "project_audit_config" {
  project = var.project_id
  service = "allServices"
	
  audit_log_config {
    log_type          = "ADMIN_READ"
    exempted_members  = []
    # No exemptions here; applies to all
  }

  audit_log_config {
    log_type          = "DATA_WRITE"
    exempted_members  = []
  }

  audit_log_config {
    log_type          = "DATA_READ"
    exempted_members  = []
  }
}

#########################################################################
## Google Logging Bucket Definition 
#########################################################################
resource "google_logging_project_bucket_config" "basic_logging" {
    project         = var.project_id
    location        = "global"
    retention_days  = 30
    bucket_id       = "${var.resource_prefix}_logs"
}

# filter - (Optional) The filter to apply when exporting logs. Only log entries that match the filter are exported. \
# e.g. filter                 = "logName:(cloudaudit.googleapis.com OR compute.googleapis.com)"
resource "google_logging_project_sink" "storage_sink" {
  project                = var.project_id
  name                   = "logs-storage-sink"
  destination            = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/${google_logging_project_bucket_config.basic_logging.bucket_id}"
  unique_writer_identity = true
  filter                 = ""
}
#########################################################################
## Google BigQuery Definition 
#########################################################################

resource "google_bigquery_dataset" "logs_dataset" {
  dataset_id  = "security_logs"
  description = "Dataset for security logs"
  location    = var.region
  project     = var.project_id
  delete_contents_on_destroy = var.force_destroy
}

resource "google_logging_project_sink" "bigquery_sink" {
  name        = "bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs_dataset.dataset_id}"
  filter      = ""

  unique_writer_identity = true
  project                = var.project_id

  bigquery_options {
    use_partitioned_tables = true # always true if it is false, logs cant export to the bigquery
  }
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "bigquery-writer" {
  project = var.project_id
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.bigquery_sink.writer_identity,
  ]

  depends_on = [google_logging_project_sink.bigquery_sink]
}

#########################################################################
## Centralized BigQuery Logging Definition
#########################################################################

# We first need to create a dataset in the admin project to store the logs
resource "google_bigquery_dataset" "centralized_logs_dataset" {
  dataset_id  = "${replace(var.project_id,"-","_")}_security_logs" # Replace function is used to replace the hyphen with underscore in the project_id since BigQuery does not allow hyphens in the dataset name
  description = "Dataset for security logs"
  location    = var.region
  project     = var.admin_project_id
  delete_contents_on_destroy = var.force_destroy # Remove this if you want an immutable dataset
}

resource "google_logging_project_sink" "centralized_bigquery_sink" {
  name        = "centralized-bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.admin_project_id}/datasets/${google_bigquery_dataset.centralized_logs_dataset.dataset_id}"
  filter      = ""

  unique_writer_identity = true
  project                = var.project_id

  bigquery_options {
    use_partitioned_tables = true # always true if it is false, logs cant export to the bigquery
  }
}

resource "google_bigquery_dataset_iam_binding" "centralized_bigquery_writer" {
  project = var.admin_project_id
  dataset_id = google_bigquery_dataset.centralized_logs_dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  members    = [
    google_logging_project_sink.centralized_bigquery_sink.writer_identity,
  ]
  depends_on = [google_bigquery_dataset.centralized_logs_dataset]
}

#########################################################################
## Centralized Google Storage Definition 
#########################################################################
# Storage bucket will be used within the SIEM
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink
resource "google_storage_bucket" "centralized_log_bucket" {
  project                     = var.admin_project_id
  name                        = "${var.logging_bucket}_${var.project_id}"
  location                    = var.region
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true
}

# filter - (Optional) The filter to apply when exporting logs. Only log entries that match the filter are exported. \
# e.g. filter                 = "logName:(cloudaudit.googleapis.com OR compute.googleapis.com)"
resource "google_logging_project_sink" "centralized_storage_sink" {
  project                = var.project_id
  name                   = "centralized-logs-storage-sink"
  destination            = "storage.googleapis.com/${google_storage_bucket.centralized_log_bucket.name}"
  unique_writer_identity = true
  filter                 = ""
}

# Because our sink uses a unique_writer, we must grant that writer access to the bucket.
resource "google_project_iam_binding" "centralized-gcs-bucket-writer" {
  project = var.admin_project_id
  role = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.centralized_storage_sink.writer_identity,
  ]

  depends_on = [google_logging_project_sink.centralized_storage_sink]
}