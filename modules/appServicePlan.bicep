param name string
param location string = resourceGroup().location
param sku object
param kind string = 'Linux'
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: sku
  properties: {
    reserved: reserved
    kind: kind
  }
}

output id string = appServicePlan.id
