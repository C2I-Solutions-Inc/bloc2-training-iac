@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

@description('Use lowercase letters and numbers only; start with a letter.')
@minLength(2)
@maxLength(7)
param storageAccountPrefix string

param location string

var environmentSettings = {
  dev: {
    sku: 'Standard_LRS'
    accessTier: 'Cool'
  }
  test: {
    sku: 'Standard_LRS'
    accessTier: 'Hot'
  }
  prod: {
    sku: 'Standard_GRS'
    accessTier: 'Hot'
  }
}

var settings = environmentSettings[environmentName]
var storageAccountName = '${storageAccountPrefix}${environmentName}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: {
    environment: environmentName
  }
  sku: {
    name: settings.sku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    accessTier: settings.accessTier
  }
}

output storageAccountName string = storageAccount.name
