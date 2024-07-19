param namePrefix string
param location string
param myPublicIP string

// Create NetworkSecurityGroup
resource networkSecurityGroups 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: '${namePrefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowMyPublicPublicIP'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '${myPublicIP}/32'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

output nsgId string = networkSecurityGroups.id
