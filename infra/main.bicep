param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param location string
param appServicePlanName string
param webAppName string
param dockerRegistryUrl string
param dockerRegistryUsername string
@secure()
param dockerRegistryPassword string
param keyVaultName string

module keyVaultModule 'modules/keyVault.bicep' = {
  name: 'deployKeyVault'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true
  }
}

module acrModule 'modules/acr.bicep' = {
  name: 'deployAcr'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: true
    adminCredentialsKeyVaultResourceId: keyVaultModule.outputs.keyVaultId
    adminCredentialsKeyVaultSecretUserName: 'acr-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-password2'
  }
  dependsOn: [
    keyVaultModule
  ]
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
    kind: 'app,linux,container'
    serverFarmResourceId: appServicePlanModule.outputs.id
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
  dependsOn: [
    appServicePlanModule
  ]
}
