output "monitoring_channel_id" {
  description = "ID of the BigQuery Logging Sink"
  value       = google_monitoring_notification_channel.email_notification_channel.id
}

output "billing_budget_id" {
  description = "ID of the Storage Bucket Logging Sink"
  value       = google_billing_budget.budget.id
}