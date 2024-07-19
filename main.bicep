param namePrefix string
param location string = resourceGroup().location
param publicKey string
param vnetAddressPrefix string
param defaultSubnetAddressPrefix string
param myPublicIP string
param adminUsername string
param vmDomain string

// Create Security Group
module nsg 'nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    location: location
    namePrefix: namePrefix
    myPublicIP: myPublicIP
  }
}

// Create Vnet
module vnet 'vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    location: location
    namePrefix: namePrefix
    nsgId: nsg.outputs.nsgId
    vnetAddressPrefix: vnetAddressPrefix
    defaultSubnetAddressPrefix: defaultSubnetAddressPrefix
  }
}

// Create VM
module vm 'vm.bicep' = {
  name: 'vmDeploy'
  params: {
    serverName: 'vm01'
    location: location
    namePrefix: namePrefix
    subnetId: vnet.outputs.defaultSubnetId
    adminUsername: adminUsername
    publicKey: publicKey
    domain: vmDomain
  }
}
