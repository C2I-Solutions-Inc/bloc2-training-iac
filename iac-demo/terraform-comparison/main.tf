resource "azurerm_storage_account" "demo" {
  name                       = var.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = var.account_replication_type
  account_kind               = "StorageV2"
  access_tier                = var.access_tier
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  tags                       = var.environment == null ? {} : { environment = var.environment }

  # Flip access_tier to "Cool" (variable default or a tfvars file), then run
  # terraform plan / terraform apply live. This previews/applies a desired-state
  # change. To show drift detection, change the tier in Azure instead, then plan
  # to reconcile it with this configuration.
}
