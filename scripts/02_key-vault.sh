#!/bin/bash
# =================================================================
# OrbitalGuard - 02: Criar Key Vault e armazenar segredos
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# =================================================================

# Variáveis
rm=rm555287
resourceGroup="rg-orbitalguard-$rm"
location="eastus"
acrName="orbitalguard$rm"
keyVaultName="kv-orbital-$rm"

MYSQL_ROOT_PASSWORD=rootorbital123
MYSQL_DATABASE=orbitalguard_db
MYSQL_USER=orbital
MYSQL_PASSWORD=orbital123
SPRING_DATASOURCE_URL="jdbc:mysql://mysql-orbitalguard:3306/orbitalguard_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
SPRING_DATASOURCE_USERNAME=orbital
SPRING_DATASOURCE_PASSWORD=orbital123

# Credenciais do ACR
ACRUSERNAME=$(az acr credential show \
  --name "$acrName" \
  --resource-group "$resourceGroup" \
  --query username \
  --output tsv)

ACRPASSWORD=$(az acr credential show \
  --name "$acrName" \
  --resource-group "$resourceGroup" \
  --query "passwords[0].value" \
  --output tsv)

# Registrar Serviço de Key Vault na Assinatura
az provider register --namespace Microsoft.KeyVault

# Criar Key Vault
if ! az keyvault show --name "$keyVaultName" --resource-group "$resourceGroup" &>/dev/null; then
  echo "Criando Key Vault: $keyVaultName"
  az keyvault create \
    --name "$keyVaultName" \
    --resource-group "$resourceGroup" \
    --location "$location"
else
  echo "Key Vault '$keyVaultName' já existe."
fi

# Conceder acesso de Administrador
az role assignment create \
  --assignee $(az account show --query user.name -o tsv) \
  --role "Key Vault Administrator" \
  --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/$resourceGroup/providers/Microsoft.KeyVault/vaults/$keyVaultName

# Armazenar segredos
echo "Armazenando segredos no Key Vault..."
az keyvault secret set --vault-name "$keyVaultName" --name mysql-root-password       --value "$MYSQL_ROOT_PASSWORD"
az keyvault secret set --vault-name "$keyVaultName" --name mysql-database            --value "$MYSQL_DATABASE"
az keyvault secret set --vault-name "$keyVaultName" --name mysql-user                --value "$MYSQL_USER"
az keyvault secret set --vault-name "$keyVaultName" --name mysql-password            --value "$MYSQL_PASSWORD"
az keyvault secret set --vault-name "$keyVaultName" --name spring-datasource-url     --value "$SPRING_DATASOURCE_URL"
az keyvault secret set --vault-name "$keyVaultName" --name spring-datasource-username --value "$SPRING_DATASOURCE_USERNAME"
az keyvault secret set --vault-name "$keyVaultName" --name spring-datasource-password --value "$SPRING_DATASOURCE_PASSWORD"
az keyvault secret set --vault-name "$keyVaultName" --name acr-username              --value "$ACRUSERNAME"
az keyvault secret set --vault-name "$keyVaultName" --name acr-password              --value "$ACRPASSWORD"

echo "=== Key Vault configurado: $keyVaultName ==="
az keyvault secret list --vault-name "$keyVaultName" --query "[].name" --output table
