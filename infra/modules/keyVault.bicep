param name string
param location string
param enableVaultForDeployment bool = true

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: '37841ca3-42b3-4aed-b215-44d6f5dcb57d' // Your actual Service Principal ID
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name 

