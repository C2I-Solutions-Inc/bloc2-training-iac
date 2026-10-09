# bloc2-training-iac
Hands-on labs and Bicep code for Bloc 2 — Infrastructure as Code training on Azure. Covers imperative vs declarative deployments, parameters, variables, modules, and environment-based deployments using the Azure

## Deployment pipelines

Two GitHub Actions pipelines deploy the `iac-demo/` examples to **dev** and then **prod** with no manual commands. Start them from **Actions → _workflow_ → Run workflow**. They take no inputs; all configuration comes from GitHub variables and the files in the repository.

```
Build (once) ──► Dev: what-if/plan ──► approval ──► deploy ──► Prod: what-if/plan ──► approval ──► deploy
                 └──────────────── same build artifact used by both stages ────────────────┘
```

| Pipeline | Build artifact | Preview (shown in the run summary) | Deploy after approval |
| --- | --- | --- | --- |
| **Deploy Bicep** (`deploy-bicep.yml` + `bicep-stage.yml`) | Lints all Bicep files, compiles `environments.bicep` to ARM JSON and `vars/<env>.bicepparam` to parameter files | `az deployment group what-if` | `az deployment group create` with the same JSON |
| **Deploy Terraform** (`deploy-terraform.yml` + `terraform-stage.yml`) | `fmt`, `validate`, and the `terraform-comparison` folder with its provider lock file and `environments/<env>.tfvars` | `terraform plan -out` (saved encrypted as an artifact) | `terraform apply` of exactly the reviewed plan |

The approval gate is the **required reviewers** protection rule on the `dev` and `prod` GitHub environments. Only the deploy/apply jobs use those environments, so the preview always runs first and the deployment waits for an approver. Rejecting dev stops the run before prod.

Terraform state is stored remotely in Azure Storage (one state file per environment: `iac-demo-dev.tfstate`, `iac-demo-prod.tfstate`). If the state changes between plan and approval, Terraform refuses the stale plan; re-run the pipeline.

### One-time setup

**1. Resource groups.** Create the dev and prod resource groups, plus a storage account and blob container for Terraform state. The pipelines do not create resource groups, so the identity only needs resource-group-scoped access.

**2. Service principal (deployment identity).** Create a Microsoft Entra app registration (or user-assigned managed identity) with **no client secret**. GitHub signs in with OpenID Connect. Add three federated credentials (issuer `https://token.actions.githubusercontent.com`, audience `api://AzureADTokenExchange`):

| Subject | Used by |
| --- | --- |
| `repo:C2I-Solutions-Inc/bloc2-training-iac:ref:refs/heads/main` | Build, what-if, and plan jobs |
| `repo:C2I-Solutions-Inc/bloc2-training-iac:environment:dev` | Dev deploy/apply jobs |
| `repo:C2I-Solutions-Inc/bloc2-training-iac:environment:prod` | Prod deploy/apply jobs |

Role assignments:

| Role | Scope |
| --- | --- |
| Contributor | Dev resource group |
| Contributor | Prod resource group |
| Storage Blob Data Contributor | Terraform state storage account (or container) |

**3. GitHub environments** (**Settings → Environments**). Create `dev` and `prod`. On each, enable **Required reviewers** and limit **Deployment branches** to `main`.

**4. GitHub variables** (**Settings → Secrets and variables → Actions → Variables**, repository level):

| Variable | Example |
| --- | --- |
| `AZURE_CLIENT_ID` | Application (client) ID of the service principal |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Subscription that holds the resource groups |
| `DEV_RESOURCE_GROUP` | `rg-iac-demo-dev` |
| `PROD_RESOURCE_GROUP` | `rg-iac-demo-prod` |
| `TF_STATE_RESOURCE_GROUP` | `rg-iac-demo-tfstate` |
| `TF_STATE_STORAGE_ACCOUNT` | `sttfstateiacdemo` |
| `TF_STATE_CONTAINER` | `tfstate` |

**5. GitHub secret** (**Settings → Secrets and variables → Actions → Secrets**). Add `TF_PLAN_ENCRYPTION_KEY`, a long random passphrase (for example `openssl rand -base64 32`). It encrypts the saved Terraform plan, which contains a state snapshot that can include storage keys.

**6. Storage account names.** Bicep generates unique names. For Terraform, set your own globally unique `storage_account_name` in `iac-demo/terraform-comparison/environments/dev.tfvars` and `prod.tfvars`.

Run the pipelines from `main`. Deployments can incur charges; delete the demo resource groups when you are done.
