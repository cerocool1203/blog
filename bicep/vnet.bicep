// ****************************************
// Azure Bicep Module:
// vNet, Subnet
// ****************************************

param location string = resourceGroup().location
param vNetName string
param address_space string
param SubnetName string
param subnetPrefix string

resource routetable 'Microsoft.Network/routeTables@2020-06-01' = {
  name: 'routetable-aks'
  location: location
  tags: {}
  properties: {
    routes: [
      {
        id: 'string'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.3.10.4'
        }
        name: 'default'
      }
    ]
    disableBgpRoutePropagation: false
  }
}

resource vnet 'Microsoft.Network/virtualnetworks@2020-06-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        address_space
      ]
    }
    subnets: [
      {
        name: SubnetName
        properties: {
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          routeTable:{
            id: routetable.id
          }
        }
      }
    ]
  }
}

output object object = vnet
output vnet_id string = vnet.id
output subnetid string = vnet.properties.subnets[0].id

