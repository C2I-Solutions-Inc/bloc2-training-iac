# Find the existing resource ID before importing:
# az storage account show --resource-group <resource-group> --name <storage-account-name> --query id --output tsv
# Then pass it in and match the other variables to the existing account:
# terraform plan -var 'import_storage_account_id=<resource-id>'
# Nothing is imported while the variable is unset (the default).
import {
  for_each = var.import_storage_account_id == null ? toset([]) : toset([var.import_storage_account_id])
  to       = azurerm_storage_account.demo
  id       = each.value
}
