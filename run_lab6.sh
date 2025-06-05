#!/bin/bash

# Script para executar o Laboratório 6 - Análise de Texto com PySpark e API
# Sistemas Distribuídos - IESB

echo "=== Laboratório 6: Análise de Texto com PySpark e API ==="
echo ""

# Função para verificar se o comando foi executado com sucesso
check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ $1"
    else
        echo "❌ Erro em: $1"
        exit 1
    fi
}

# Função para aguardar o serviço estar pronto
wait_for_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=0
    
    echo "Aguardando $service_name na porta $port..."
    while [ $attempt -lt $max_attempts ]; do
        if curl -s -f http://localhost:$port > /dev/null 2>&1; then
            echo "✅ $service_name está pronto!"
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 2
    done
    echo "⚠️  $service_name pode não estar totalmente pronto, mas continuando..."
}

echo "1. Parando ambiente Docker se estiver rodando..."
sudo docker compose down
check_status "Ambiente Docker parado"

echo ""
echo "2. Construindo as imagens Docker..."
sudo docker compose build
check_status "Imagens Docker construídas"

echo ""
echo "3. Iniciando o ambiente Docker..."
sudo docker compose up -d
check_status "Ambiente Docker iniciado"

echo ""
echo "4. Aguardando inicialização dos serviços (60 segundos)..."
sleep 60

echo ""
echo "5. Verificando se os containers estão rodando..."
sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "6. Copiando arquivos do Gutenberg para o HDFS..."
# Aguardar o HDFS estar pronto
echo "Aguardando HDFS estar pronto..."
sleep 30

# Executar o comando de cópia para o HDFS
sudo docker exec -it spark-master bash -c "cd /user_data/gutenberg && hdfs dfs -put *.txt /datasets/" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Arquivos copiados para o HDFS"
else
    echo "⚠️  Tentando novamente em 15 segundos..."
    sleep 15
    sudo docker exec -it spark-master bash -c "cd /user_data/gutenberg && hdfs dfs -put *.txt /datasets/" 2>/dev/null
    check_status "Arquivos copiados para o HDFS (segunda tentativa)"
fi

echo ""
echo "7. Verificando arquivos no HDFS..."
sudo docker exec -it spark-master hdfs dfs -ls /datasets/
check_status "Verificação do HDFS"

echo ""
echo "8. Aguardando API estar pronta..."
wait_for_service "API" 8001

echo ""
echo "9. Testando a API..."
echo "Testando endpoint principal:"
curl -s http://localhost:8001/ | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8001/
echo ""
echo "Testando endpoint do microserviço:"
curl -s http://localhost:8001/micro_servico | python3 -m json.tool 2>/dev/null || curl -s http://localhost:8001/micro_servico
echo ""

echo ""
echo "=== LABORATÓRIO 6 CONFIGURADO COM SUCESSO! ==="
echo ""
echo "📊 Serviços disponíveis:"
echo "   • Spark Master UI: http://localhost:8080"
echo "   • Jupyter Notebook: http://localhost:8888"
echo "   • HDFS NameNode UI: http://localhost:9870"
echo "   • YARN ResourceManager: http://localhost:8088"
echo "   • API FastAPI: http://localhost:8001"
echo "   • API Swagger UI: http://localhost:8001/docs"
echo ""
echo "📝 Próximos passos:"
echo "   1. Acesse o Jupyter Notebook em http://localhost:8888"
echo "   2. Abra o notebook 'contar_palavras.ipynb'"
echo "   3. Execute as células para fazer a análise de palavras"
echo "   4. Teste a API em http://localhost:8001/docs"
echo ""
echo "🔧 Para parar o ambiente: sudo docker compose down"