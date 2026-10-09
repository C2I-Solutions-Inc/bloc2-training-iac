resource "azurerm_storage_account" "demo" {
  name                       = "stbloc2demo2026"
  resource_group_name        = "rg-iac-demo"
  location                   = "canadacentral"
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  access_tier                = "Hot"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  # Flip access_tier to "Cool", then run terraform plan / terraform apply live.
  # This previews/applies a desired-state change. To show drift detection,
  # change the tier in Azure instead, then plan to reconcile it with this file.
}
