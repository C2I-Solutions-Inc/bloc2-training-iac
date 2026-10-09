# resource_group_name comes from the PROD_RESOURCE_GROUP GitHub variable.
# Storage account names are global: replace with your own available name.
environment              = "prod"
storage_account_name     = "stbloc2tfprod2026"
location                 = "canadacentral"
account_replication_type = "GRS"
access_tier              = "Hot"
