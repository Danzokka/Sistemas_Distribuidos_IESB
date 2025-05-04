#!/bin/bash

# Script de pós-instalação do Docker
# Permite executar o Docker sem sudo

echo "Configurando Docker para execução sem privilégios de superusuário..."

# Criar grupo docker (pode já existir)
echo "Criando grupo docker..."
sudo groupadd docker

# Adicionar o usuário atual ao grupo docker
echo "Adicionando usuário atual ao grupo docker..."
sudo usermod -aG docker $USER

# Aplicar as mudanças de grupo
echo "Aplicando mudanças de grupo..."
newgrp docker

# Corrigir permissões da pasta .docker se existir
if [ -d "$HOME/.docker" ]; then
    echo "Corrigindo permissões da pasta .docker..."
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
fi

# Configurar Docker para iniciar com o sistema
echo "Configurando Docker para iniciar automaticamente com o sistema..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Pós-instalação concluída!"
echo "Agora você pode executar comandos docker sem sudo."
echo "IMPORTANTE: Pode ser necessário fazer logout e login novamente para que as mudanças de grupo tenham efeito."

# Teste se a configuração foi bem-sucedida
echo "Testando a configuração..."
docker run hello-world