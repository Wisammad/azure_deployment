param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param location string
param appServicePlanName string
param webAppName string
param dockerRegistryUrl string
param dockerRegistryUsername string
param dockerRegistryPassword string

module acrModule 'modules/acr.bicep' = {
  name: 'deployAcr'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: true
  }
}

module appServicePlanModule 'modules/appServicePlan.bicep' = {
  name: 'deployAppServicePlan'
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
  }
}

module webAppModule 'modules/webApp.bicep' = {
  name: 'deployWebApp'
  params: {
    name: webAppName
    location: location
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: dockerRegistryUrl
      DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryPassword
    }
  }
}
