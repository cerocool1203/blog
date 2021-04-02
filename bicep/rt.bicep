// ****************************************
// Azure Bicep Module:
// Route Table
// ****************************************

param location string = resourceGroup().location

resource routetable 'Microsoft.Network/routeTables@2020-03-01' = {
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

output object object = routetable
