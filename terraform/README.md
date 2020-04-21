# terraform

## Create SP And Storage Account For Terraform

```shell
az login
az account set --subscription <YOUR_SUBSCRIPTION_NAME>

SP_OBJECT=$(az ad sp create-for-rbac --name chiguhagu-terraform | jq .)
export SP_CLIENT_SECRET=$(echo $SP_OBJECT | jq .password)
export SP_CLIENT_ID=$(az ad sp list --display-name chiguhagu-terraform --query '[0]' | jq .appId)
export SP_OBJECT_ID=$(az ad sp list --display-name chiguhagu-terraform --query '[0]' | jq .objectId)
export SP_TENANT_ID=$(echo $SP_OBJECT | jq .tenant)

RAND_ID=`printf %04d $RANDOM`
echo $RAND_ID
STORAGE_ACCOUNT_NAME="k8sgitopstf"$RAND_ID

az group create --name k8sgitops-tf --location japaneast
az storage account create --resource-group k8sgitops-tf --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
ACCOUNT_KEY=$(az storage account keys list --resource-group k8sgitops-tf --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
az storage container create --name k8sgitops --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
```

## Create SP For AKS

```shell
az login
az account set --subscription <YOUR_SUBSCRIPTION_NAME>

SP_OBJECT=$(az ad sp create-for-rbac --name chiguhagu-aks | jq .)
export SP_CLIENT_SECRET=$(echo $SP_OBJECT | jq .password)
export SP_CLIENT_ID=$(az ad sp list --display-name chiguhagu-aks --query '[0]' | jq .appId)
export SP_OBJECT_ID=$(az ad sp list --display-name chiguhagu-aks --query '[0]' | jq .objectId)
export SP_TENANT_ID=$(echo $SP_OBJECT | jq .tenant)
```
