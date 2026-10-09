# resource_group_name comes from the DEV_RESOURCE_GROUP GitHub variable.
# Storage account names are global: replace with your own available name.
environment              = "dev"
storage_account_name     = "stbloc2tfdev2026"
location                 = "canadacentral"
account_replication_type = "LRS"
access_tier              = "Cool"
