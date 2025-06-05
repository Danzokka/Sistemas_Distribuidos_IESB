# Sistemas Distribuídos - IESB

Este repositório contém o ambiente Dockerizado do Apache Hadoop com Spark para a disciplina de Sistemas Distribuídos do IESB.

## 🚀 Laboratório 6 - Análise de Texto com PySpark e API

### Pré-requisitos
- Docker e Docker Compose
- Git
- Curl (para testes)

### 📦 Scripts Principais

O projeto foi simplificado para usar apenas **3 scripts principais**:

1. **`install.sh`** - Instalação inicial do ambiente
2. **`post-install.sh`** - Configurações pós-instalação  
3. **`lab6.sh`** - Script completo do Laboratório 6

### 🔧 Instalação Rápida

```bash
# 1. Clone o repositório
git clone <repository-url>
cd Sistemas_Distribuidos_IESB

# 2. Instalar dependências
./install.sh

# 3. Configuração pós-instalação
./post-install.sh

# 4. Executar Laboratório 6 completo
./lab6.sh setup
```

### 📋 Comandos do lab6.sh

```bash
./lab6.sh start       # Inicia o ambiente Docker
./lab6.sh stop        # Para o ambiente Docker  
./lab6.sh restart     # Reinicia o ambiente
./lab6.sh status      # Mostra status dos serviços
./lab6.sh diagnose    # Diagnóstico completo do cluster
./lab6.sh copy-data   # Copia dados do Gutenberg para HDFS
./lab6.sh test-api    # Testa endpoints da API
./lab6.sh setup       # Setup completo (recomendado)
./lab6.sh logs        # Mostra logs do cluster
./lab6.sh help        # Ajuda
```

### 🌐 Serviços Disponíveis

| Serviço | URL | Descrição |
|---------|-----|-----------|
| **Jupyter Notebook** | http://localhost:8888 | Interface para notebooks PySpark |
| **FastAPI** | http://localhost:8000 | API do microserviço |
| **API Docs (Swagger)** | http://localhost:8000/docs | Documentação interativa |
| **Spark Master UI** | http://localhost:8080 | Interface do Spark Master |
| **Hadoop NameNode** | http://localhost:9870 | Interface do HDFS |
| **YARN ResourceManager** | http://localhost:8088 | Gerenciador de recursos |

### 📊 Datasets

O laboratório utiliza 5 livros do Project Gutenberg:
- Romeo and Juliet (Shakespeare)
- Pride and Prejudice (Jane Austen) 
- Middlemarch (George Eliot)
- A Room with a View (E.M. Forster)
- Moby Dick (Herman Melville)

### 🎯 Objetivos do Laboratório

1. **Análise de Texto com PySpark**: Contar palavras nos livros usando processamento distribuído
2. **HDFS**: Armazenar datasets no sistema de arquivos distribuído
3. **API REST**: Criar microserviço com FastAPI para consultas
4. **Monitoramento**: Usar interfaces web para acompanhar o processamento

### 📝 Como Executar

1. **Setup completo:**
   ```bash
   ./lab6.sh setup
   ```

2. **Abrir Jupyter:**
   - Acesse: http://localhost:8888
   - Abra: `contar_palavras.ipynb`
   - Execute todas as células

3. **Testar API:**
   - Acesse: http://localhost:8000/docs
   - Teste os endpoints disponíveis

4. **Monitorar cluster:**
   - Spark UI: http://localhost:8080
   - HDFS: http://localhost:9870

### 🔍 Troubleshooting

Se houver problemas:

```bash
# Diagnóstico completo
./lab6.sh diagnose

# Ver logs
./lab6.sh logs

# Reiniciar ambiente
./lab6.sh restart

# Status atual
./lab6.sh status
```

### 📚 Estrutura do Projeto

```
├── install.sh              # Instalação inicial
├── post-install.sh         # Pós-instalação
├── lab6.sh                 # Script principal do Lab 6
├── docker-compose.yml      # Configuração dos containers
├── user_data/
│   ├── contar_palavras.ipynb  # Notebook PySpark
│   ├── api.py              # Código da API FastAPI
│   └── gutenberg/          # Datasets (criado automaticamente)
└── hadoop/                 # Configurações Hadoop/Spark
```

### 🎓 Para Estudantes

1. **Execute o setup completo** com `./lab6.sh setup`
2. **Analise o código** do notebook `contar_palavras.ipynb`
3. **Teste a API** em http://localhost:8000/docs
4. **Monitore o processamento** nas interfaces web
5. **Experimente** modificar o código e executar novamente

### 📞 Suporte

Em caso de dúvidas:
1. Execute `./lab6.sh diagnose` para verificar problemas
2. Consulte os logs com `./lab6.sh logs`
3. Verifique se todos os serviços estão ativos com `./lab6.sh status`

---

**Laboratório desenvolvido para IESB - Sistemas Distribuídos**
