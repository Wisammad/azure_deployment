param name string
param location string
param serverFarmResourceId string
param siteConfig object
param appSettingsKeyValuePairs object

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
    appSettings: appSettingsKeyValuePairs
  }
  kind: 'app'
}
