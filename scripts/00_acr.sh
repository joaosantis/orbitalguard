#!/bin/bash
# =================================================================
# OrbitalGuard - 00: Criar ACR e publicar imagens Docker
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# FIAP - Turma 2TDSPW
# =================================================================
# Como usar:
#   az login
#   az account show
#   bash scripts/00_acr.sh
# =================================================================

# Variáveis — ALTERE SEU RM SE NECESSÁRIO
rm=rm555287
resourceGroup="rg-orbitalguard-$rm"
acrName="orbitalguard$rm"
location="eastus"
tag="v1"

# Registrar o Serviço de ACR na Assinatura
az provider register --namespace Microsoft.ContainerRegistry

# Criar Resource Group (se não existir)
if ! az group show --name "$resourceGroup" &>/dev/null; then
  echo "Criando Resource Group: $resourceGroup"
  az group create --name "$resourceGroup" --location "$location"
fi

# Criar Azure Container Registry
if ! az acr show --name "$acrName" --resource-group "$resourceGroup" &>/dev/null; then
  echo "Criando ACR: $acrName"
  az acr create \
    --resource-group "$resourceGroup" \
    --name "$acrName" \
    --sku Basic \
    --admin-enabled true \
    --location "$location"
else
  echo "ACR '$acrName' já existe."
fi

# Login no ACR
az acr login --name "$acrName"

# Build e Push da imagem da API (Spring Boot)
echo "Build e Push: orbitalguard-api"
docker build \
  -t $acrName.azurecr.io/orbitalguard-api:$tag \
  -f dockerfiles/Dockerfile .

docker push $acrName.azurecr.io/orbitalguard-api:$tag

# Build e Push da imagem do MySQL (com init.sql)
echo "Build e Push: orbitalguard-mysql"
docker build \
  -t $acrName.azurecr.io/orbitalguard-mysql:$tag \
  -f dockerfiles/Dockerfile.mysql .

docker push $acrName.azurecr.io/orbitalguard-mysql:$tag

echo "=== Imagens publicadas no ACR: $acrName.azurecr.io ==="
az acr repository list --name "$acrName" --output table
