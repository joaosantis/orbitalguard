#!/bin/bash
# =================================================================
# OrbitalGuard - 04: Deploy API Java no Azure Container Instances
# Global Solution 2026/2 - DevOps Tools & Cloud Computing
# =================================================================

# Variáveis
rm=rm555287
resourceGroup="rg-orbitalguard-$rm"
acrName="orbitalguard$rm"
aciName="api-orbitalguard"
aciNameMysql="mysql-orbitalguard"
imageName="orbitalguard-api"
tag="v1"
keyVaultName="kv-orbital-$rm"

# Recuperar IP público do container MySQL
mysqlPublicIP=$(az container show \
  --resource-group "$resourceGroup" \
  --name "$aciNameMysql" \
  --query ipAddress.ip \
  --output tsv)

echo "IP do MySQL: $mysqlPublicIP"

# Registrar Serviço de ACI na Assinatura
az provider register --namespace Microsoft.ContainerInstance

# Deploy do Container API Java (Spring Boot)
echo "Criando container API Java no ACI: $aciName"
az container create \
  --resource-group "$resourceGroup" \
  --name "$aciName" \
  --image "$acrName.azurecr.io/$imageName:$tag" \
  --cpu 1 \
  --memory 1 \
  --os-type Linux \
  --dns-name-label "api-orbitalguard-$rm" \
  --ports 8080 \
  --registry-login-server "$acrName.azurecr.io" \
  --registry-username $(az keyvault secret show --vault-name "$keyVaultName" --name acr-username --query value -o tsv) \
  --registry-password $(az keyvault secret show --vault-name "$keyVaultName" --name acr-password --query value -o tsv) \
  --environment-variables \
    SPRING_DATASOURCE_URL=$(az keyvault secret show --name spring-datasource-url --vault-name "$keyVaultName" --query value -o tsv | sed "s/mysql-orbitalguard/$mysqlPublicIP/") \
    SPRING_DATASOURCE_USERNAME=$(az keyvault secret show --name spring-datasource-username --vault-name "$keyVaultName" --query value -o tsv) \
  --secure-environment-variables \
    SPRING_DATASOURCE_PASSWORD=$(az keyvault secret show --name spring-datasource-password --vault-name "$keyVaultName" --query value -o tsv) \
  --restart-policy Always \
  --output table

# Exibir informações de acesso
echo ""
echo "=== Container API criado ==="
fqdnJava=$(az container show \
  --resource-group "$resourceGroup" \
  --name "$aciName" \
  --query ipAddress.fqdn \
  --output tsv)

echo "URL da API: http://$fqdnJava:8080"
echo ""
echo "Testando endpoints:"
echo "  curl -X GET http://$fqdnJava:8080/cidades"
echo "  curl -X GET http://$fqdnJava:8080/alertas"
echo "  curl -X GET http://$fqdnJava:8080/alertas/ativos"
