#!/bin/bash

# Script para testar a API FastAPI
# Sistemas Distribuídos - IESB

echo "=== Teste da API FastAPI ==="
echo ""

# Verificar se o container está rodando
if ! sudo docker ps | grep -q "spark-master"; then
    echo "❌ Container spark-master não está rodando!"
    echo "Execute primeiro: sudo docker compose up -d"
    exit 1
fi

echo "🔍 Testando conectividade da API..."

# Função para testar endpoint
test_endpoint() {
    local endpoint=$1
    local description=$2
    
    echo ""
    echo "📡 Testando: $description"
    echo "URL: http://localhost:8001$endpoint"
    echo "Resposta:"
    
    response=$(curl -s -w "\n%{http_code}" http://localhost:8001$endpoint)
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "200" ]; then
        echo "✅ Status: $http_code"
        echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    else
        echo "❌ Status: $http_code"
        echo "$body"
    fi
}

# Testar endpoints
test_endpoint "/" "Endpoint raiz"
test_endpoint "/micro_servico" "Endpoint do microserviço"

echo ""
echo "🌐 Links úteis:"
echo "   • API Base: http://localhost:8001"
echo "   • Swagger UI: http://localhost:8001/docs"
echo "   • ReDoc: http://localhost:8001/redoc"

echo ""
echo "🔧 Para ver logs da API:"
echo "   sudo docker logs spark-master | grep uvicorn"
