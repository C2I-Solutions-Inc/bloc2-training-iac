@description('Use lowercase letters and numbers only; start with a letter.')
@minLength(2)
@maxLength(11)
param storageAccountPrefix string = 'stbloc2'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageAccountSku string = 'Standard_LRS'

@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

var storageAccountName = '${storageAccountPrefix}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    accessTier: accessTier
  }
}

output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output primaryEndpoints object = storageAccount.properties.primaryEndpoints
