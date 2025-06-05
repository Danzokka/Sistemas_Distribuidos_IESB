#!/bin/bash

# ===================================================
# LABORATÓRIO 6 - SISTEMAS DISTRIBUÍDOS IESB
# Script consolidado para setup, teste e monitoramento
# ===================================================

set -e  # Para em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Função para verificar se comando existe
check_command() {
    if ! command -v $1 &> /dev/null; then
        error "Comando '$1' não encontrado. Execute primeiro: ./install.sh"
        exit 1
    fi
}

# Função para aguardar serviço
wait_for_service() {
    local url=$1
    local service_name=$2
    local max_attempts=30
    local attempt=1
    
    log "Aguardando $service_name..."
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" > /dev/null 2>&1; then
            log "$service_name está respondendo!"
            return 0
        fi
        sleep 2
        attempt=$((attempt + 1))
    done
    
    warn "$service_name não respondeu após $max_attempts tentativas"
    return 1
}

# Função para diagnóstico do cluster
diagnose_cluster() {
    log "=== DIAGNÓSTICO DO CLUSTER ==="
    
    info "1. Verificando containers Docker..."
    if ! sudo docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "(spark-master|spark-worker)"; then
        error "Containers não estão rodando!"
        return 1
    fi
    
    info "2. Verificando HDFS..."
    local datanode_count=$(sudo docker exec spark-master hdfs dfsadmin -report 2>/dev/null | grep "Live datanodes" | grep -o "([0-9]*)" | tr -d "()" || echo "0")
    if [ "$datanode_count" -eq 0 ]; then
        error "Nenhum DataNode ativo!"
        return 1
    else
        log "DataNodes ativos: $datanode_count"
    fi
    
    info "3. Verificando conectividade de serviços..."
    local services=("http://localhost:8888" "http://localhost:8000" "http://localhost:8080" "http://localhost:9870")
    for service in "${services[@]}"; do
        if curl -s "$service" > /dev/null 2>&1; then
            log "✅ $service"
        else
            warn "❌ $service não responde"
        fi
    done
    
    return 0
}

# Função para verificar status
check_status() {
    log "=== STATUS DO LABORATÓRIO 6 ==="
    
    # Containers
    local container_count=$(sudo docker ps --format "{{.Names}}" | grep -E "(spark-master|spark-worker)" | wc -l)
    info "Containers ativos: $container_count/3"
    
    # HDFS
    if sudo docker exec spark-master hdfs dfsadmin -report > /dev/null 2>&1; then
        local hdfs_files=$(sudo docker exec spark-master hdfs dfs -ls /datasets/*.txt 2>/dev/null | wc -l || echo "0")
        info "Arquivos no HDFS: $hdfs_files"
        
        if [ "$hdfs_files" -gt 0 ]; then
            local total_size=$(sudo docker exec spark-master hdfs dfs -du -s -h /datasets 2>/dev/null | awk '{print $1}' || echo "0")
            info "Tamanho total dos dados: ${total_size}B"
        fi
    else
        warn "HDFS não acessível"
    fi
    
    # URLs dos serviços
    echo ""
    log "🌐 SERVIÇOS DISPONÍVEIS:"
    echo "  • Jupyter Notebook: http://localhost:8888"
    echo "  • FastAPI: http://localhost:8000"
    echo "  • Swagger Docs: http://localhost:8000/docs"
    echo "  • Spark Master UI: http://localhost:8080"
    echo "  • Hadoop NameNode: http://localhost:9870"
    echo "  • YARN ResourceManager: http://localhost:8088"
}

# Função para copiar dados para HDFS
copy_to_hdfs() {
    log "=== COPIANDO DADOS PARA HDFS ==="
    
    # Verificar se arquivos existem localmente, se não, fazer download
    if [ ! -d "user_data/gutenberg" ] || [ $(ls user_data/gutenberg/*.txt 2>/dev/null | wc -l) -eq 0 ]; then
        warn "Arquivos do Gutenberg não encontrados. Fazendo download..."
        if ! download_gutenberg; then
            error "Falha no download dos livros"
            return 1
        fi
    fi
    
    info "Arquivos locais encontrados:"
    ls -lh user_data/gutenberg/*.txt | awk '{print "  • " $9 " (" $5 ")"}'
    
    # Criar diretórios no HDFS se não existirem
    sudo docker exec spark-master hdfs dfs -mkdir -p /datasets 2>/dev/null || true
    sudo docker exec spark-master hdfs dfs -mkdir -p /datasets_processed 2>/dev/null || true
    
    # Copiar arquivos
    info "Copiando arquivos para HDFS..."
    if sudo docker exec spark-master hdfs dfs -put -f /user_data/gutenberg/*.txt /datasets/ 2>/dev/null; then
        log "✅ Arquivos copiados com sucesso!"
        
        # Verificar arquivos copiados
        info "Arquivos no HDFS:"
        sudo docker exec spark-master hdfs dfs -ls /datasets/*.txt | awk '{print "  • " $8 " (" $5 " bytes)"}'
        
        return 0
    else
        error "Falha ao copiar arquivos para HDFS"
        return 1
    fi
}

# Função para testar API
test_api() {
    log "=== TESTANDO API FASTAPI ==="
    
    if ! wait_for_service "http://localhost:8000" "FastAPI"; then
        error "API não está respondendo"
        return 1
    fi
    
    # Testar endpoints principais
    local endpoints=("/" "/health" "/datasets" "/micro_servico")
    
    for endpoint in "${endpoints[@]}"; do
        info "Testando: $endpoint"
        if curl -s "http://localhost:8000$endpoint" | python3 -m json.tool > /dev/null 2>&1; then
            log "✅ $endpoint respondendo"
        else
            warn "❌ $endpoint com problemas"
        fi
    done
    
    echo ""
    log "🚀 API Links:"
    echo "  • API Base: http://localhost:8000"
    echo "  • Swagger UI: http://localhost:8000/docs"
    echo "  • ReDoc: http://localhost:8000/redoc"
}

# Função para download dos livros do Gutenberg
download_gutenberg() {
    log "=== DOWNLOAD DOS LIVROS DO GUTENBERG ==="
    
    # Criar diretório se não existir
    mkdir -p user_data/gutenberg
    cd user_data/gutenberg
    
    # URLs dos livros
    local books=(
        "https://www.gutenberg.org/files/1513/1513-0.txt|Romeo_and_Juliet.txt"
        "https://www.gutenberg.org/files/145/145-0.txt|Middlemarch.txt"
        "https://www.gutenberg.org/files/1342/1342-0.txt|Pride_and_Prejudice.txt"
        "https://www.gutenberg.org/files/2641/2641-0.txt|A_Room_with_a_View.txt"
        "https://www.gutenberg.org/files/2701/2701-0.txt|Moby_Dick.txt"
    )
    
    # Verificar se já existem arquivos
    local existing_files=$(ls *.txt 2>/dev/null | wc -l)
    if [ "$existing_files" -eq 5 ]; then
        log "✅ Livros já baixados (5 arquivos encontrados)"
        cd ../..
        return 0
    fi
    
    info "Baixando livros do Project Gutenberg..."
    
    for book in "${books[@]}"; do
        local url=$(echo "$book" | cut -d'|' -f1)
        local filename=$(echo "$book" | cut -d'|' -f2)
        
        if [ ! -f "$filename" ]; then
            info "Baixando: $filename..."
            if curl -s -L "$url" -o "$filename"; then
                log "✅ $filename baixado"
            else
                error "Falha ao baixar $filename"
                cd ../..
                return 1
            fi
        else
            log "✅ $filename já existe"
        fi
    done
    
    # Verificar downloads
    info "Verificando arquivos baixados:"
    ls -lh *.txt | awk '{print "  • " $9 " (" $5 ")"}'
    
    cd ../..
    log "✅ Download dos livros concluído!"
    return 0
}

# Função para mostrar ajuda
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  start       - Inicia o ambiente Docker"
    echo "  stop        - Para o ambiente Docker"
    echo "  restart     - Reinicia o ambiente Docker"
    echo "  status      - Mostra status dos serviços"
    echo "  diagnose    - Executa diagnóstico completo"
    echo "  copy-data   - Copia dados do Gutenberg para HDFS"
    echo "  test-api    - Testa endpoints da API"
    echo "  setup       - Setup completo (start + copy-data + test)"
    echo "  logs        - Mostra logs do spark-master"
    echo "  download     - Faz o download dos livros do Gutenberg"
    echo "  help        - Mostra esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 setup     # Configuração completa"
    echo "  $0 status    # Verificar status"
    echo "  $0 diagnose  # Diagnóstico detalhado"
}

# Função principal
main() {
    local command=${1:-help}
    
    case $command in
        "start")
            log "Iniciando ambiente Docker..."
            check_command "docker"
            sudo docker compose up -d
            log "Aguardando inicialização dos serviços..."
            sleep 15
            wait_for_service "http://localhost:8888" "Jupyter"
            wait_for_service "http://localhost:8000" "FastAPI"
            log "✅ Ambiente iniciado!"
            ;;
            
        "stop")
            log "Parando ambiente Docker..."
            sudo docker compose down
            log "✅ Ambiente parado!"
            ;;
            
        "restart")
            log "Reiniciando ambiente Docker..."
            sudo docker compose restart
            sleep 10
            log "✅ Ambiente reiniciado!"
            ;;
            
        "status")
            check_status
            ;;
            
        "diagnose")
            diagnose_cluster
            ;;
            
        "copy-data")
            copy_to_hdfs
            ;;
            
        "test-api")
            test_api
            ;;
            
        "download")
            download_gutenberg
            ;;
            
        "setup")
            log "=== SETUP COMPLETO DO LABORATÓRIO 6 ==="
            
            # Verificar pré-requisitos
            check_command "docker"
            check_command "curl"
            
            # Iniciar ambiente
            log "1. Iniciando ambiente Docker..."
            sudo docker compose up -d
            
            # Aguardar inicialização
            log "2. Aguardando inicialização dos serviços..."
            sleep 20
            
            # Verificar se serviços estão rodando
            if ! wait_for_service "http://localhost:8888" "Jupyter"; then
                error "Jupyter não iniciou corretamente"
                exit 1
            fi
            
            if ! wait_for_service "http://localhost:8000" "FastAPI"; then
                error "FastAPI não iniciou corretamente"
                exit 1
            fi
            
            # Diagnóstico
            log "3. Executando diagnóstico..."
            if ! diagnose_cluster; then
                error "Problemas detectados no cluster"
                exit 1
            fi
            
            # Copiar dados
            log "4. Copiando dados para HDFS..."
            if ! copy_to_hdfs; then
                error "Falha ao copiar dados"
                exit 1
            fi
            
            # Testar API
            log "5. Testando API..."
            test_api
            
            # Status final
            echo ""
            log "=== SETUP CONCLUÍDO COM SUCESSO! ==="
            check_status
            
            echo ""
            log "🚀 PRÓXIMOS PASSOS:"
            echo "  1. Acesse o Jupyter: http://localhost:8888"
            echo "  2. Abra o notebook: contar_palavras.ipynb"
            echo "  3. Execute todas as células"
            echo "  4. Teste a API: http://localhost:8000/docs"
            ;;
            
        "logs")
            log "Mostrando logs do spark-master..."
            sudo docker logs spark-master --tail 50
            ;;
            
        "help"|*)
            show_help
            ;;
    esac
}

# Verificar se está no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    error "Execute este script no diretório raiz do projeto (onde está o docker-compose.yml)"
    exit 1
fi

# Executar comando
main "$@"
