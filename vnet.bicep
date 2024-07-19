param namePrefix string
param location string
param vnetAddressPrefix string
param defaultSubnetAddressPrefix string
param nsgId string

// Create VirtualNetwork
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${namePrefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    // Create Subnet
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: defaultSubnetAddressPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
    ]
  }

  resource defaultSubnet 'subnets' existing = {
    name: 'default'
  }
}

output defaultSubnetId string = virtualNetwork::defaultSubnet.id
