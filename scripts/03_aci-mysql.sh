#!/bin/bash
# =================================================================
# OrbitalGuard - 03: Deploy MySQL no Azure Container Instances
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# =================================================================

# Variáveis
rm=rm555287
resourceGroup="rg-orbitalguard-$rm"
acrName="orbitalguard$rm"
aciName="mysql-orbitalguard"
imageName="orbitalguard-mysql"
tag="v1"
storageAccountName="orbitalguarddata$rm"
fileShareName="mysql-orbital-volume"
keyVaultName="kv-orbital-$rm"

# Recuperar chave do Storage Account (para montar o volume)
storageKey=$(az storage account keys list \
  --resource-group "$resourceGroup" \
  --account-name "$storageAccountName" \
  --query "[0].value" \
  --output tsv)

# Registrar Serviço de ACI na Assinatura
az provider register --namespace Microsoft.ContainerInstance

# Deploy do Container MySQL
echo "Criando container MySQL no ACI: $aciName"
az container create \
  --resource-group "$resourceGroup" \
  --name "$aciName" \
  --image "$acrName.azurecr.io/$imageName:$tag" \
  --cpu 1 \
  --memory 1 \
  --os-type Linux \
  --dns-name-label "mysql-orbitalguard-$rm" \
  --ports 3306 \
  --registry-login-server "$acrName.azurecr.io" \
  --registry-username $(az keyvault secret show --vault-name "$keyVaultName" --name acr-username --query value -o tsv) \
  --registry-password $(az keyvault secret show --vault-name "$keyVaultName" --name acr-password --query value -o tsv) \
  --azure-file-volume-account-name "$storageAccountName" \
  --azure-file-volume-account-key "$storageKey" \
  --azure-file-volume-share-name "$fileShareName" \
  --azure-file-volume-mount-path /var/lib/mysql \
  --environment-variables \
    MYSQL_DATABASE=$(az keyvault secret show --vault-name "$keyVaultName" --name mysql-database --query value -o tsv) \
    MYSQL_USER=$(az keyvault secret show --vault-name "$keyVaultName" --name mysql-user --query value -o tsv) \
  --secure-environment-variables \
    MYSQL_ROOT_PASSWORD=$(az keyvault secret show --vault-name "$keyVaultName" --name mysql-root-password --query value -o tsv) \
    MYSQL_PASSWORD=$(az keyvault secret show --vault-name "$keyVaultName" --name mysql-password --query value -o tsv) \
  --restart-policy Always \
  --output table

echo "=== Container MySQL criado ==="
az container show \
  --resource-group "$resourceGroup" \
  --name "$aciName" \
  --query "ipAddress" \
  --output table
