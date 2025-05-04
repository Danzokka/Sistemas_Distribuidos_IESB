# Cluster Hadoop/Spark com Docker

Este projeto implementa um cluster Hadoop/Spark utilizando Docker, permitindo a execução de processamento distribuído de dados em um ambiente virtualizado.

## Tecnologias Utilizadas

[![Technologies](https://go-skill-icons.vercel.app/api/icons?i=linux,ubuntu,debian,bash,docker,git,github)](https://github.com/Danzokka)

## Pré-requisitos

- Docker e Docker Compose
- Git
- Make

## Estrutura do Projeto

O projeto consiste em três imagens Docker principais:

- `spark-base`: Imagem base com Hadoop e Spark instalados
- `spark-master`: Nó mestre do cluster
- `spark-worker`: Nós de trabalho do cluster

## Como Usar

### 1. Clone o repositório

```bash
git clone https://github.com/Danzokka/Sistemas_Distribuidos_IESB.git
cd Sistemas_Distribuidos_IESB
```

### 2. Faça download dos arquivos binários

Crie o diretório bin se não existir:

```bash
mkdir -p hadoop/spark-base/bin
```

Baixe os arquivos necessários para o diretório bin:

```bash
wget -P hadoop/spark-base/bin https://archive.apache.org/dist/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
wget -P hadoop/spark-base/bin https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
```

### 3. Construa as imagens Docker

```bash
make build
```

Este comando executará o Makefile que construirá as três imagens Docker necessárias:

- danzokka/spark-base-hadoop
- danzokka/spark-master-hadoop
- danzokka/spark-worker-hadoop

### 4. Inicie o cluster

```bash
docker-compose up -d
```

### 5. Acesse as interfaces web

- Spark Master: http://localhost:8080
- HDFS NameNode: http://localhost:9870
- YARN Resource Manager: http://localhost:8088
- Jupyter Notebook: http://localhost:8888
- Spark History Server: http://localhost:18080

### 6. Para parar o cluster

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
