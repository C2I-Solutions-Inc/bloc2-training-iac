targetScope = 'subscription'

@description('Use letters and numbers only.')
@minLength(1)
@maxLength(9)
param warehouseCode string = 'lab1'

param location string = 'canadacentral'

resource labResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-lab1-${warehouseCode}'
  location: location
}

module storage 'storage.bicep' = {
  name: 'storage-${warehouseCode}'
  scope: labResourceGroup
  params: {
    warehouseCode: warehouseCode
    location: location
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output storageAccountId string = storage.outputs.storageAccountId
output primaryBlobEndpoint string = storage.outputs.primaryBlobEndpoint
