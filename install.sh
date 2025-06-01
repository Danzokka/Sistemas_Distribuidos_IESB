#!/bin/bash

# Script de instalação do Docker e configuração do ambiente
# para o cluster Hadoop/Spark

echo "Atualizando o sistema..."
sudo apt-get update

echo "Instalando pré-requisitos..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adicionando a chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Adicionando o repositório do Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Atualizando informações do repositório..."
sudo apt update

echo "Verificando políticas do Docker..."
sudo apt-cache policy docker-ce

echo "Instalando Docker CE e Make..."
sudo apt-get install -y docker-ce make

echo "Verificando status do Docker..."
sudo systemctl status docker

echo "Atualizando o sistema..."
sudo apt-get upgrade -y

echo "Instalação concluída!"

# Criar diretório bin se não existir
mkdir -p hadoop/spark-base/bin

echo "Preparando download dos arquivos necessários para Hadoop e Spark..."
echo "Download pode demorar dependendo da sua conexão"

# Download dos arquivos necessários
echo "Baixando Hadoop..."
wget -P hadoop/spark-base/bin https://archive.apache.org/dist/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz

echo "Baixando Spark..."
wget -P hadoop/spark-base/bin https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz

echo "Downloads concluídos!"