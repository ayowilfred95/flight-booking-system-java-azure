#### Set up your Azure environment

**Completed**

**100 XP**

**6 minutes**

In this unit, you'll use the Azure CLI to create the Azure resources that will be needed in later units. Before you start entering commands, make sure Docker Desktop is installed and running.

**Using the Azure CLI, perform the following steps:**

**Authenticate with Azure Resource Manager**

Use the following command in your CLI to sign in:

```bash
az login
```

**Select an Azure subscription**

Azure subscriptions are logical containers used to provision resources in Azure. You'll need to locate the subscription ID (SubscriptionId) that you plan to use in this module. Use this command to list your Azure subscriptions:

```bash
az account list --output table
```

Use the following command to ensure you're using an Azure subscription that allows you to create resources for the purposes of this module, substituting your subscription ID (SubscriptionId) of choice:

```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

**Define local variables**

To simplify the commands that we'll execute later, set up the following environment variables:

**Note**

Replace `<YOUR_AZURE_REGION>` with your region of choice; for example: eastus.

Replace `<YOUR_CONTAINER_REGISTRY>` with a unique value, because this is used to generate a unique FQDN (fully qualified domain name) for your Azure Container Registry when it is created; for example: someuniquevaluejavacontainerregistry.

Replace `<YOUR_UNIQUE_DNS_PREFIX_TO_ACCESS_YOUR_AKS_CLUSTER>` with a unique value, because it's used to generate a unique FQDN (fully qualified domain name) for your Azure Kubernetes Cluster when it is created; for example: someuniquevaluejavacontainerizationdemoaks.

```bash
AZ_RESOURCE_GROUP=javacontainerizationdemorg
AZ_CONTAINER_REGISTRY=<YOUR_CONTAINER_REGISTRY>
AZ_KUBERNETES_CLUSTER=javacontainerizationdemoaks
AZ_LOCATION=<YOUR_AZURE_REGION>
AZ_KUBERNETES_CLUSTER_DNS_PREFIX=<YOUR_UNIQUE_DNS_PREFIX_TO_ACCESS_YOUR_AKS_CLUSTER>
```

**Create an Azure Resource Group**

Azure resource groups are Azure containers in Azure subscriptions for holding related resources for an Azure solution. Create a Resource group by using the following command in your CLI:

```bash
az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION \
    | jq
```

**Note**

This module uses the jq tool, which is installed by default on Azure Cloud Shell to display JSON data and make it more readable.

If you don't want to use the jq tool, you can safely remove the `| jq` part of all commands in this module.

**Create an Azure Container Registry**

Azure Container Registry allows you to build, store, and manage container images, which are ultimately where the container image for the Java app will be stored. Create a Container registry by using the following command:

```bash
az acr create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_CONTAINER_REGISTRY \
    --sku Basic \
    | jq
```

**Configure Azure CLI to use this newly created Azure Container Registry:**

```bash
az configure \
    --defaults acr=$AZ_CONTAINER_REGISTRY
```

**Authenticate to the newly created Azure Container Registry:**

```bash
az acr login -n $AZ_CONTAINER_REGISTRY
```

**Create an Azure Kubernetes Cluster**

You'll need an Azure Kubernetes Cluster to deploy the Java app (container image) to. Create an AKS Cluster:

```bash
az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_KUBERNETES_CLUSTER \
    --attach-acr $AZ_CONTAINER_REGISTRY \
    --dns-name-prefix=$AZ_KUBERNETES_CLUSTER_DNS_PREFIX \
    --generate-ssh-keys \
    | jq
```

**In case you see this error while creating the cluster**
```bash
ERROR: (QuotaExceeded) Preflight validation check for resource(s) for container service flightbookingsystemkubernetes in resource group MC_javaflightcontainerization_flightbookingsystemkubernetes_eastus failed. Message: Operation could not be completed as it results in exceeding approved Total Regional Cores quota. Additional details - Deployment Model: Resource Manager, Location: eastus, Current Limit: 4, Current Usage: 0, Additional Required: 6, (Minimum) New Limit Required: 6. Submit a request for Quota increase at https://aka.ms/ProdportalCRP/#blade/Microsoft_Azure_Capacity/UsageAndQuota.ReactView/Parameters/%7B%22subscriptionId%22:%2262b729bc-acad-4045-b66a-2bc5dd380cf3%22,%22command%22:%22openQuotaApprovalBlade%22,%22quotas%22:[%7B%22location%22:%22eastus%22,%22providerId%22:%22Microsoft.Compute%22,%22resourceName%22:%22cores%22,%22quotaRequest%22:%7B%22properties%22:%7B%22limit%22:6,%22unit%22:%22Count%22,%22name%22:%7B%22value%22:%22cores%22%7D%7D%7D%7D]%7D by specifying parameters listed in the ‘Details’ section for deployment to succeed. Please read more about quota limits at https://docs.microsoft.com/en-us/azure/azure-supportability/regional-quota-requests. Details:
Code: QuotaExceeded
Message: Preflight validation check for resource(s) for container service flightbookingsystemkubernetes in resource group MC_javaflightcontainerization_flightbookingsystemkubernetes_eastus failed. Message: Operation could not be completed as it results in exceeding approved Total Regional Cores quota. Additional details - Deployment Model: Resource Manager, Location: eastus, Current Limit: 4, Current Usage: 0, Additional Required: 6, (Minimum) New Limit Required: 6. Submit a request for Quota increase at https://aka.ms/ProdportalCRP/#blade/Microsoft_Azure_Capacity/UsageAndQuota.ReactView/Parameters/%7B%22subscriptionId%22:%2262b729bc-acad-4045-b66a-2bc5dd380cf3%22,%22command%22:%22openQuotaApprovalBlade%22,%22quotas%22:[%7B%22location%22:%22eastus%22,%22providerId%22:%22Microsoft.Compute%22,%22resourceName%22:%22cores%22,%22quotaRequest%22:%7B%22properties%22:%7B%22limit%22:6,%22unit%22:%22Count%22,%22name%22:%7B%22value%22:%22cores%22%7D%7D%7D%7D]%7D by specifying parameters listed in the ‘Details’ section for deployment to succeed. Please read more about quota limits at https://docs.microsoft.com/en-us/azure/azure-supportability/regional-quota-requests. Details:
```

**Run this command to list all regions**

```bash
az account list-locations -o table
```

**Run this command to see how many quota is associated to a region**

```bash
az vm list-skus --location eastus --query "[?resourceType=='virtualMachines' && name=='Standard_DS2_v2'].{Location:location, Resource:resourceType, Sku:name, Cores:capabilities[?name=='vCPUs'].value | [0]}"
```

**output should look like this**

```bash
[
  {
    "Cores": "2",
    "Location": null,
    "Resource": "virtualMachines",
    "Sku": "Standard_DS2_v2"
  }
]
```

**Then finally run this command to create the kubernetes cluster**

```bash
az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_KUBERNETES_CLUSTER \
    --location eastus \
    --node-count 1 \
    --node-vm-size Standard_DS2_v2 \
    --generate-ssh-keys \
    | jq
```

**Note**

Creating an Azure Kubernetes Cluster can take up to 10 minutes. Once you run the command above, you can let it continue in your Azure CLI tab and move on to the next unit.

**Push the container image to Azure ontainer Registry**

```bash
docker tag flightbookingsystemsample $AZ_CONTAINER_REGISTRY.azurecr.io/flightbookingsystemsample
```

**Second, push the container image to Azure Container Registry:**

```bash
docker push $AZ_CONTAINER_REGISTRY.azurecr.io/flightbookingsystemsample
```

**Once the push completes, you can view the Azure Container Registry image metadata of the newly pushed image. Run the following command in your CLI:**

```bash
az acr repository show -n $AZ_CONTAINER_REGISTRY --image flightbookingsystemsample:latest
```

**Configure kubectl to connect to your Kubernetes cluster using the az aks get-credentials command. Run the following command in your CLI:**

```bash
az aks get-credentials --resource-group $AZ_RESOURCE_GROUP --name $AZ_KUBERNETES_CLUSTER
```


**Refer to this documentation**

https://learn.microsoft.com/en-us/training/modules/containerize-deploy-java-app-aks/6-deploy



**If you get ErrImgPullBack**

**Run this command**

```bash
az aks update -n name-of-the-cluster -g name-of-the-resource-group --attach-acr name-of-the-acr
```
