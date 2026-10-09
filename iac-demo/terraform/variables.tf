# Defaults match the original single-account demo; the pipeline overrides them
# with environments/<environment>.tfvars and TF_VAR_resource_group_name.
variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase letters or digits)."
  type        = string
  default     = "stbloc2demo2026"
}

variable "resource_group_name" {
  description = "Resource group to create (if missing) and deploy into."
  type        = string
  default     = "rg-iac-demo"
}

variable "location" {
  type    = string
  default = "canadaeast"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

variable "environment" {
  description = "Optional environment tag."
  type        = string
  default     = null
}

variable "import_storage_account_id" {
  description = "Resource ID of an existing storage account to import (see import.tf)."
  type        = string
  default     = null
}
