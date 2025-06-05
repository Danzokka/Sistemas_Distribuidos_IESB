#!/bin/bash

# Script para copiar dados do Gutenberg para o HDFS
# Sistemas Distribuídos - IESB

echo "=== Copiando dados do Gutenberg para o HDFS ==="
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

# Verificar se o container spark-master está rodando
if ! sudo docker ps | grep -q "spark-master"; then
    echo "❌ Container spark-master não está rodando!"
    echo "Execute primeiro: sudo docker compose up -d"
    exit 1
fi

echo "1. Verificando arquivos do Gutenberg..."
sudo docker exec -it spark-master ls -la /user_data/gutenberg/
check_status "Verificação dos arquivos locais"

echo ""
echo "2. Verificando estrutura do HDFS..."
sudo docker exec -it spark-master hdfs dfs -ls /
check_status "Verificação da estrutura do HDFS"

echo ""
echo "3. Copiando arquivos para o HDFS..."
sudo docker exec -it spark-master bash -c "cd /user_data/gutenberg && hdfs dfs -put *.txt /datasets/"
check_status "Cópia dos arquivos para o HDFS"

echo ""
echo "4. Verificando arquivos copiados no HDFS..."
sudo docker exec -it spark-master hdfs dfs -ls /datasets/
check_status "Verificação dos arquivos no HDFS"

echo ""
echo "5. Verificando tamanho dos arquivos..."
sudo docker exec -it spark-master hdfs dfs -du -h /datasets/
check_status "Verificação do tamanho dos arquivos"

echo ""
echo "=== DADOS COPIADOS COM SUCESSO PARA O HDFS! ==="
echo ""
echo "📊 Arquivos disponíveis no HDFS em /datasets/:"
sudo docker exec -it spark-master hdfs dfs -ls /datasets/ | grep "\.txt$"
echo ""
echo "🚀 Agora você pode executar o notebook 'contar_palavras.ipynb' no Jupyter!"
