param name string
param location string
param sku object
param kind string
param reserved bool

resource servicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: reserved
  }
}

output serverFarmResourceId string = servicePlan.id
