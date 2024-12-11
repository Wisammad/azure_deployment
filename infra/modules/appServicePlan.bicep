param name string
param location string
param sku object

resource servicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: sku
  properties: {
    reserved: true // Linux service plan
    kind: 'Linux'
  }
}

output id string = servicePlan.id
