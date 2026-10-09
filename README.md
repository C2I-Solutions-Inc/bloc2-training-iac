# bloc2-training-iac
Hands-on labs and Bicep code for Bloc 2 — Infrastructure as Code training on Azure. Covers imperative vs declarative deployments, parameters, variables, modules, and environment-based deployments using the Azure

## Automated deployment pipelines

Two manually triggered GitHub Actions workflows show that the `iac-demo/` examples can be deployed without running commands by hand. Start them from **Actions → _workflow_ → Run workflow**.

1. **Deploy Bicep** (`.github/workflows/deploy-bicep.yml`) — builds every Bicep template and parameter file, creates the resource group (idempotent), then runs `what-if` and deploys the selected example (`all`, `declarative`, `benefits`, `environments` with the dev/prod parameter file, or `module-example`). Deployment outputs appear in the run summary.
2. **Deploy Terraform** (`.github/workflows/deploy-terraform.yml`) — run after the Bicep pipeline. It runs `terraform fmt`, `init`, `validate` and `plan`, and also `apply` when `action` is set to `apply`. If the storage account in `main.tf` already exists (for example, created by `declarative.bicep`), the pipeline fills in `import.tf` so Terraform imports the account rather than failing. If the account doesn't exist, it removes `import.tf` for that run and Terraform creates the account. The pipeline stops if the resource group does not exist.

### Setup

The workflows sign in to Azure using OpenID Connect (no stored passwords). Create a Microsoft Entra app registration or user-assigned managed identity with a federated credential for this repository. Give it the **Contributor** role on the target subscription, which `module-example` needs to create its resource group. Then add these repository secrets:

| Secret | Value |
| --- | --- |
| `AZURE_CLIENT_ID` | Application (client) ID |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Target subscription ID |

Terraform state is not persisted between runs in this demo; use a remote backend (for example, an Azure Storage container) for real workloads. Both workflows share a concurrency group so they never run at the same time. Deployments can incur charges; delete the demo resource groups afterwards.
