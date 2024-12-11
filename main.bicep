param location string = resourceGroup().location
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param appServicePlanName string
param webAppName string

// Deploy Azure Container Registry
module acrModule './modules/acr.bicep' = {
  name: 'acrDeployment'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: true
  }
}

// Deploy Azure Service Plan for Linux
module appServicePlanModule './modules/appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

// Deploy Azure Web App for Linux Containers
module webAppModule './modules/webApp.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: [
      {
        name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
        value: 'false'
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_URL'
        value: 'https://${acrModule.outputs.loginServer}/'
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_USERNAME'
        value: acrModule.outputs.adminUsername
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
        value: acrModule.outputs.adminPassword
      }
    ]
  }
}
