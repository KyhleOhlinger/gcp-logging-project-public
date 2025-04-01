output "bigquery_logging_sink_id" {
  description = "ID of the BigQuery Logging Sink"
  value       = google_logging_project_sink.bigquery_sink.id
}

output "logging_bucket_id" {
  description = "ID of the Logging Bucket"
  value       = google_logging_project_bucket_config.basic_logging.id
}

output "centralized_bigquery_sink_id" {
  description = "ID of the BigQuery Logging Sink"
  value       = google_logging_project_sink.centralized_bigquery_sink.id
}

output "centralized_logging_bucket_id" {
  description = "ID of the Storage Bucket Logging Sink"
  value       = google_storage_bucket.centralized_log_bucket.id
}

output "centralized_bucket_logging_sink_id" {
  description = "ID of the Storage Bucket Logging Sink"
  value       = google_logging_project_sink.centralized_storage_sink.id
}