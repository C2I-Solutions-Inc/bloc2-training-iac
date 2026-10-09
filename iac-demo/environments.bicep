targetScope = 'subscription'

@description('Resource group to create if missing, then deploy the storage account into. Always supplied via --parameters at deploy time; the empty default only lets az bicep build-params compile the .bicepparam files, which intentionally omit it.')
param resourceGroupName string = ''

@description('Location for the resource group and its resources.')
param location string = 'canadaeast'

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('Use lowercase letters and numbers only; start with a letter.')
@minLength(2)
@maxLength(7)
param storageAccountPrefix string = 'stbloc2'

// Subscription-scope deployment: creates the resource group if it doesn't
// already exist (idempotent either way), so an accidentally deleted
// resource group is recreated on the next run instead of failing. The
// storage account itself still lives in environments-storage.bicep, a
// resource-group-scoped module, since resources can only be deployed at the
// scope of the file (or a module's explicit scope).
resource environmentResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    environment: environmentName
  }
}

module storage 'environments-storage.bicep' = {
  name: 'storage-${environmentName}'
  scope: environmentResourceGroup
  params: {
    environmentName: environmentName
    storageAccountPrefix: storageAccountPrefix
    location: location
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output environmentName string = environmentName
output resourceGroupName string = environmentResourceGroup.name
