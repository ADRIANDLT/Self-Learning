param name string
param location string = resourceGroup().location
param kind string = 'app'
param serverFarmResourceId string
param siteConfig object
param appSettingsKeyValuePairs array

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: webApp
  name: 'appsettings'
  properties: appSettingsKeyValuePairs
}
