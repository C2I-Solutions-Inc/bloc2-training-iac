# Find the existing resource ID before importing:
# az storage account show --resource-group <resource-group> --name <storage-account-name> --query id --output tsv
# Replace the placeholders and match main.tf to the existing account before applying.
import {
  to = azurerm_storage_account.demo
  id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
}
