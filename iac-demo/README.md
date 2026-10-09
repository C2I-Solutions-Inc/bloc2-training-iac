# IaC learning progression

These examples focus on resource groups and storage accounts:

1. **Imperative** — `imperative.azcli` creates resources through ordered commands.
2. **Idempotent** — repeat `idempotent.azcli` to see the same resource group reused.
3. **Declarative** — `declarative.bicep` describes the desired storage account state.
4. **Benefits** — `benefits.bicep` adds parameters, validation, deterministic naming with `uniqueString(resourceGroup().id)`, and useful outputs.
5. **Environments** — `environments.bicep` reuses one template with dev/test/prod settings; `vars/` supplies dev and prod parameters.
6. **Modules** — `module-example/main.bicep` creates a resource group at subscription scope and composes the resource-group-scoped storage module.
7. **Terraform comparison** — compare the equivalent storage resource, preview changes with `plan`, apply them, and import an existing account into Terraform state.

## Try the examples

Use Azure CLI with Bicep installed, an Azure sign-in (`az login`), and your chosen subscription (`az account set --subscription <subscription-id>`). Run the following from this folder in Bash:

```bash
bash imperative.azcli
bash idempotent.azcli
az deployment group create --resource-group rg-iac-demo --template-file declarative.bicep
az deployment group create --resource-group rg-iac-demo --template-file benefits.bicep
az deployment group create --resource-group rg-iac-demo --parameters vars/dev.bicepparam
az deployment group create --resource-group rg-iac-demo --parameters vars/prod.bicepparam
az deployment sub create --location canadacentral --template-file module-example/main.bicep --parameters warehouseCode=demo
```

Replace the hardcoded `stbloc2demo2026` name in the CLI, declarative, and Terraform examples with your own globally available name. Storage names must be 3–24 lowercase letters or digits; use lowercase alphanumeric prefixes and alphanumeric warehouse codes. `uniqueString` produces a stable 13-character suffix to avoid typical cross-resource-group collisions, but global availability is still checked by Azure, not mathematically guaranteed.

The examples are alternative approaches, not one combined deployment. Use separate resource groups for dev and prod in a real environment. Deploying multiple storage templates into the same group creates additional accounts. Deployments can incur charges.

### Terraform (1.5 or newer)

The resource group must already exist. For an existing account, replace the placeholders in `import.tf` with the ID returned by its Azure CLI command, and align `main.tf` with the account's name, group, location, and settings. For a new account, comment out the import block first and choose an unused name.

```bash
cd terraform-comparison
terraform init
terraform plan
terraform apply
```

Flip `access_tier` to `"Cool"` to preview a configuration change. To demonstrate **drift**, change the tier outside Terraform, then run `terraform plan` to show how Terraform would restore the declared tier. Keep Terraform state local for this demo and do not commit it; it can contain sensitive values.

After the session, delete only the demo resource groups you created to avoid ongoing charges.
