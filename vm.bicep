param namePrefix string
param location string
param serverName string
param subnetId string
param publicKey string
param domain string

@secure()
param adminUsername string

// Create Public IP
resource vmPublcIP 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${namePrefix}-${serverName}-public-ip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 5
    dnsSettings: {
      domainNameLabel: domain
      fqdn: '${domain}.${location}.cloudapp.azure.com'
    }
  }
}

// Create vmNic
resource vmNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${namePrefix}-${serverName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', vmPublcIP.name)
            properties: {
              deleteOption: 'Delete'
            }
          }
        }
      }
    ]
  }
}

// Create VM
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: '${namePrefix}-${serverName}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    
    priority: 'Spot'
    evictionPolicy: 'Deallocate'
    storageProfile: {
      osDisk: {
        name: '${namePrefix}-${serverName}-osDisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
      }
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'        
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    osProfile: {
      computerName: serverName
      adminUsername: adminUsername
      linuxConfiguration: {
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: publicKey
            }
          ]
        }
        disablePasswordAuthentication: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
    }
  }
}
