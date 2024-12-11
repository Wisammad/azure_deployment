param name string
param location string
param sku object
param kind string = 'Linux'
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: sku
  // Move 'kind' to the root level, not in properties
  kind: kind
  properties: {
    reserved: reserved    // This property indicates Linux hosting
  }
}

output id string = appServicePlan.id
