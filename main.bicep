param containerRegistryName string
param containerRegistryLocation string
param containerRegistryImageName string
param containerRegistryImageVersion string
param appServicePlanName string
param appServicePlanLocation string
param appServicePlanSku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}
param appServicePlanKind string = 'Linux'
param appServicePlanReserved bool = true
param webAppName string
param webAppLocation string
param webAppKind string = 'app'

module acr './modules/azureContainerRegistry.bicep' = {
  name: '${containerRegistryName}-acr'
  params: {
    name: containerRegistryName
    location: containerRegistryLocation
    acrAdminUserEnabled: true
  }
}

module servicePlan './modules/azureServicePlan.bicep' = {
  name: '${appServicePlanName}-asp'
  params: {
    name: appServicePlanName
    location: appServicePlanLocation
    sku: appServicePlanSku
    kind: appServicePlanKind
    reserved: appServicePlanReserved
  }
}

module webApp './modules/azureWebApp.bicep' = {
  name: '${webAppName}-webapp'
  params: {
    name: webAppName
    location: webAppLocation
    kind: webAppKind
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
      appSettingsKeyValuePairs: {
        WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
        DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryName}.azurecr.io'
        DOCKER_REGISTRY_SERVER_USERNAME: acr.properties.credentials.username
        DOCKER_REGISTRY_SERVER_PASSWORD: acr.properties.credentials.passwords[0].value
      }
    }
  }
}
