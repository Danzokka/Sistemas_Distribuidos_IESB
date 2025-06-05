# Cluster Hadoop/Spark com Docker

Este projeto implementa um cluster Hadoop/Spark utilizando Docker, permitindo a execução de processamento distribuído de dados em um ambiente virtualizado.

## Tecnologias Utilizadas

[![Technologies](https://go-skill-icons.vercel.app/api/icons?i=linux,ubuntu,debian,bash,java,python,hadoop,pyspark,docker,virtualbox,vscode,git,github)](https://github.com/Danzokka)

## Pré-requisitos

- Sistema Ubuntu Linux
- Conexão com a internet para download dos pacotes
- Permissões de administrador (sudo)

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/Danzokka/Sistemas_Distribuidos_IESB.git
cd Sistemas_Distribuidos_IESB
```

### 2. Execute o script de instalação

O script `install.sh` automatiza a instalação do Docker, Make e faz o download dos arquivos necessários do Hadoop e Spark:

```bash
chmod +x install.sh
sudo ./install.sh
```

Este script executará as seguintes etapas:

- Atualização do sistema
- Instalação das dependências necessárias
- Configuração do repositório Docker
- Instalação do Docker CE e Make
- Verificação do status do Docker
- Criação do diretório `hadoop/spark-base/bin`
- Download dos arquivos Hadoop e Spark para o diretório bin

### 3. Configuração do Docker sem sudo (opcional)

Para executar o Docker sem privilégios de superusuário, execute o script de pós-instalação:

```bash
chmod +x post-install.sh
./post-install.sh
```

Este script:

- Cria o grupo `docker` (se não existir)
- Adiciona seu usuário ao grupo
- Corrige as permissões do diretório `.docker`
- Configura o Docker para iniciar automaticamente com o sistema
- Testa a configuração com uma imagem "hello-world"

**Importante:** Pode ser necessário fazer logout e login novamente para que as mudanças de grupo tenham efeito completo.

## Estrutura do Projeto

O projeto consiste em três imagens Docker principais:

- `spark-base`: Imagem base com Hadoop e Spark instalados
- `spark-master`: Nó mestre do cluster
- `spark-worker`: Nós de trabalho do cluster

## Como Usar

### 1. Construa as imagens Docker

```bash
make build
```

Este comando executará o Makefile que construirá as três imagens Docker necessárias:

- danzokka/spark-base-hadoop
- danzokka/spark-master-hadoop
- danzokka/spark-worker-hadoop

### 2. Inicie o cluster

```bash
docker-compose up -d
```

### 3. Acesse as interfaces web

- Spark Master: http://localhost:8080
- HDFS NameNode: http://localhost:9870
- YARN Resource Manager: http://localhost:8088
- Jupyter Notebook: http://localhost:8888
- Spark History Server: http://localhost:18080

### 4. Para parar o cluster

```bash
docker-compose down
```

## Laboratório 6: Análise de Texto com PySpark e API

### Execução Automática (Recomendado)

Para executar o laboratório 6 automaticamente, utilize o script fornecido:

```bash
./run_lab6.sh
```

Este script executará todos os passos necessários:
- Construção das imagens Docker
- Inicialização do ambiente
- Cópia dos livros do Gutenberg para o HDFS
- Configuração da API FastAPI
- Verificação dos serviços

### Execução Manual

#### 1. Preparação do Ambiente

```bash
# Construir e iniciar o ambiente
sudo docker compose build
sudo docker compose up -d
```

#### 2. Copiar Dados para o HDFS

```bash
# Usar o script dedicado
./copy_to_hdfs.sh

# OU executar manualmente:
sudo docker exec -it spark-master bash -c "cd /user_data/gutenberg && hdfs dfs -put *.txt /datasets/"
```

#### 3. Verificar os Dados

```bash
# Listar arquivos no HDFS
sudo docker exec -it spark-master hdfs dfs -ls /datasets/
```

### Serviços Disponíveis no Lab 6

- **Spark Master UI**: http://localhost:8080
- **Jupyter Notebook**: http://localhost:8888
- **HDFS NameNode UI**: http://localhost:9870
- **YARN ResourceManager**: http://localhost:8088
- **API FastAPI**: http://localhost:8001
- **API Swagger UI**: http://localhost:8001/docs

### Análise de Dados

1. Acesse o Jupyter Notebook em http://localhost:8888
2. Abra o notebook `contar_palavras.ipynb`
3. Execute as células para processar os livros do Gutenberg
4. Observe os resultados da contagem de palavras

### API de Microserviços

A API FastAPI fornece endpoints para:
- **GET /**: Endpoint de teste básico
- **GET /micro_servico**: Endpoint para processamento de dados
- **GET /docs**: Documentação interativa Swagger

### Dados Utilizados

O laboratório utiliza os seguintes livros do Project Gutenberg:
- Romeo and Juliet (Shakespeare)
- Middlemarch (George Eliot)
- Pride and Prejudice (Jane Austen)
- A Room with a View (E.M. Forster)
- Moby Dick (Herman Melville)

### Scripts Auxiliares

- `run_lab6.sh`: Execução completa do laboratório
- `copy_to_hdfs.sh`: Cópia específica dos dados para o HDFS

## Funcionalidades

- Cluster distribuído com HDFS para armazenamento
- YARN como gerenciador de recursos
- Spark para processamento de dados
- Jupyter Notebook para análises interativas

## Volumes

O diretório `user_data` é montado como volume no contêiner master, permitindo compartilhar arquivos entre o host e o cluster.

## Créditos

Este projeto foi inspirado nos ensinamentos do Professor Raul Souza.

[![YouTube Channel](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@raulcarvalhodesouza)

---

Desenvolvido por [Rafael Dantas Boeira](https://github.com/Danzokka)
