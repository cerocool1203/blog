// ****************************************
// Azure Bicep Module:
// Private AKS
// ****************************************

param location string = resourceGroup().location
param AKSName string
param subnet_id string 
param group_id string
param dns_prefix string
param kubernetes_version string
param node_count int
param auto_scaling_min_count int
param auto_scaling_max_count int
param max_pods int
param os_disk_size_gb int
param node_size string



resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: AKSName
  location: location
  properties: {
    kubernetesVersion: kubernetes_version 
    enableRBAC: true
    dnsPrefix: dns_prefix
    aadProfile: {
      managed: true
      adminGroupObjectIDs: [
        group_id
      ]
    }
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '192.168.254.0/24'
      dnsServiceIP: '192.168.254.10'
      dockerBridgeCidr: '172.22.0.1/16'
      outboundType: 'userDefinedRouting'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    addonProfiles: {
      azurepolicy: {
        enabled: false
      }
      httpApplicationRouting: {
        enabled: false
      }
    }
    agentPoolProfiles: [
      {
        name: 'agentpool'
        mode:'System'
        osDiskSizeGB: os_disk_size_gb
        count: node_count
        vmSize: node_size
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        maxPods: max_pods
        vnetSubnetID: subnet_id
        enableAutoScaling: true
        minCount: auto_scaling_min_count
        maxCount: auto_scaling_max_count
        orchestratorVersion: kubernetes_version
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
      }
    ]
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output object object = aks
output aks_id string = aks.properties.privateFQDN
output aks_identity object = aks.properties.identityProfile


