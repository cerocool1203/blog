// ****************************************
// Azure Bicep Deployment
// This deployemnt will the below components for Private AKS deployment.
//RG, vNet, Subnet
//Route table and association the subnet as per PRivate AKS requeriments the next hope will be my NVA (Azure Firewall)
//Private AKS 
// ****************************************

targetScope = 'subscription'

param location string = 'australia east'

var RgName          = 'aks-rg-test'
var AKSName         = 'aks-development'
var AKSvNetName     = 'aks-vnet'
var AKSsubnetName   = 'aks-subnet'
var AKSsubnetPrefix = '10.0.3.0/25'

//Resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RgName
  location: location
}

module vnet './vnet.bicep' = {
  name: AKSvNetName
  scope: resourceGroup(rg.name)
  params: {
    location: location
    vNetName: AKSvNetName
    address_space: '10.0.3.0/24'
    SubnetName: AKSsubnetName
    subnetPrefix: AKSsubnetPrefix
  }
  dependsOn: [
    rg
  ]
}

module aks './aks.bicep' = {
  name: AKSName
  scope: resourceGroup(rg.name)
  params: {
    location: location
    subnet_id: vnet.outputs.subnetid
    group_id: 'bad1b814-cb6e-4027-afd2-ee0d27aef0e1'
    AKSName: 'aks-dev'
    dns_prefix: 'dev'
    kubernetes_version: '1.18.14'
    node_count: 1
    auto_scaling_min_count: 1
    auto_scaling_max_count: 3
    max_pods: 50
    os_disk_size_gb: 64
    node_size: 'Standard_D2_v3'
  }
  dependsOn: [
    vnet
  ]
}

output vnetid string    = vnet.outputs.vnet_id
output aksid string     = aks.outputs.aks_id
output aks_iden object  = aks.outputs.aks_identity
