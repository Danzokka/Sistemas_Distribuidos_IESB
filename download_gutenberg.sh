#!/bin/bash

# Script para download dos livros do Projeto Gutenberg
# Autor: Sistema de Distribuição IESB
# Data: $(date)

echo "=== Download dos Livros do Projeto Gutenberg ==="
echo "Criando diretório gutenberg..."

# Criar diretório se não existir
mkdir -p user_data/gutenberg

echo "Fazendo download dos livros..."

# Download Romeo and Juliet
echo "Baixando Romeo and Juliet..."
wget https://www.gutenberg.org/cache/epub/1513/pg1513.txt -O user_data/gutenberg/Romeo_and_Juliet.txt

# Download Middlemarch
echo "Baixando Middlemarch..."
wget https://www.gutenberg.org/cache/epub/145/pg145.txt -O user_data/gutenberg/Middlemarch.txt

# Download Pride and Prejudice
echo "Baixando Pride and Prejudice..."
wget https://www.gutenberg.org/cache/epub/1342/pg1342.txt -O user_data/gutenberg/Pride_and_Prejudice.txt

# Download A Room with a View
echo "Baixando A Room with a View..."
wget https://www.gutenberg.org/cache/epub/2641/pg2641.txt -O user_data/gutenberg/A_Room_with_a_View.txt

# Download Moby Dick
echo "Baixando Moby Dick..."
wget https://www.gutenberg.org/cache/epub/2701/pg2701.txt -O user_data/gutenberg/Moby_Dick.txt

echo "=== Download concluído! ==="
echo "Arquivos salvos em user_data/gutenberg/"
ls -la user_data/gutenberg/
