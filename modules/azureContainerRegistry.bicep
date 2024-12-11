param name string
param location string
param acrAdminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output adminUsername string = listCredentials(acr.id, '2021-09-01-preview').username
output adminPassword string = listCredentials(acr.id, '2021-09-01-preview').passwords[0].value
