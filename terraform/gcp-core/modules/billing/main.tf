
#########################################################################
## Google Billing Metrics Definition 
#########################################################################
resource "google_monitoring_notification_channel" "email_notification_channel" {
  display_name = "${var.resource_prefix} Email Notification Channel"
  type         = "email"

  labels = {
    email_address = var.billing_email_address
  }
}

resource "google_billing_budget" "budget" {
  billing_account = var.billing_account
  display_name    = "${var.resource_prefix} Billing Budget"
  
  budget_filter {
	  projects               =["projects/${var.project_id}"]
	  credit_types_treatment = "INCLUDE_ALL_CREDITS"
}
  
  amount {
    specified_amount {
      currency_code = var.billing_currency
      units         = "25"
    }
  }

  threshold_rules {
    threshold_percent =  0.5
  }

  threshold_rules{
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }
    
  all_updates_rule {
    monitoring_notification_channels  = [google_monitoring_notification_channel.email_notification_channel.id,]
    disable_default_iam_recipients    = true
  }
}