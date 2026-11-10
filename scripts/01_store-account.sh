#!/bin/bash
# =================================================================
# OrbitalGuard - 01: Criar Storage Account e File Share (volume MySQL)
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# =================================================================

# Variáveis
rm=rm555287
resourceGroup="rg-orbitalguard-$rm"
storageAccountName="orbitalguarddata$rm"
fileShareName="mysql-orbital-volume"
location="eastus"

# Registrar Serviço de Storage na Assinatura
az provider register --namespace Microsoft.Storage

# Criar Conta de Armazenamento
if ! az storage account show --name "$storageAccountName" --resource-group "$resourceGroup" &>/dev/null; then
  echo "Criando Storage Account: $storageAccountName"
  az storage account create \
    --resource-group "$resourceGroup" \
    --name "$storageAccountName" \
    --location "$location" \
    --sku Standard_LRS
else
  echo "Storage Account '$storageAccountName' já existe."
fi

# Recuperar connection string
connection_string=$(az storage account show-connection-string \
  --name "$storageAccountName" \
  --resource-group "$resourceGroup" \
  --query connectionString \
  --output tsv)

# Criar File Share (volume do banco de dados)
if ! az storage share exists --name "$fileShareName" --account-name "$storageAccountName" --connection-string "$connection_string" | grep -q true; then
  echo "Criando File Share: $fileShareName"
  az storage share create \
    --name "$fileShareName" \
    --account-name "$storageAccountName" \
    --connection-string "$connection_string"
else
  echo "File Share '$fileShareName' já existe."
fi

echo "=== Storage Account criado: $storageAccountName ==="
echo "    File Share: $fileShareName"
