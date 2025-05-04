# Cluster Hadoop/Spark com Docker

Este projeto implementa um cluster Hadoop/Spark utilizando Docker, permitindo a execução de processamento distribuído de dados em um ambiente virtualizado.

## Tecnologias Utilizadas

[![Technologies](https://go-skill-icons.vercel.app/api/icons?i=linux,ubuntu,debian,bash,docker,git,github)](https://github.com/Danzokka)

## Pré-requisitos

- Sistema Ubuntu Linux
- Conexão com a internet para download dos pacotes
- Permissões de administrador (sudo)

## Instalação

### 1. Clone o repositório

```bash
git clone <repositório>
cd cluster-hadoop
```

### 2. Execute o script de instalação

O script `install.sh` automatiza a instalação do Docker, Make e faz o download dos arquivos necessários do Hadoop e Spark:

```bash
chmod +x install.sh
./install.sh
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
