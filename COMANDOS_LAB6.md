# Comandos Importantes do Laboratório 6

## Execução Rápida
```bash
# Executar tudo automaticamente
./run_lab6.sh

# Apenas copiar dados para HDFS
./copy_to_hdfs.sh

# Testar apenas a API
./test_api.sh
```

## Comandos Manuais

### Gerenciamento do Ambiente
```bash
# Construir imagens
sudo docker compose build

# Iniciar ambiente
sudo docker compose up -d

# Parar ambiente
sudo docker compose down

# Ver status dos containers
sudo docker ps
```

### Trabalhar com HDFS
```bash
# Copiar arquivos para HDFS
sudo docker exec -it spark-master bash -c "cd /user_data/gutenberg && hdfs dfs -put *.txt /datasets/"

# Listar arquivos no HDFS
sudo docker exec -it spark-master hdfs dfs -ls /datasets/

# Ver tamanho dos arquivos
sudo docker exec -it spark-master hdfs dfs -du -h /datasets/

# Remover arquivos do HDFS (se necessário)
sudo docker exec -it spark-master hdfs dfs -rm /datasets/*.txt
```

### Testar API
```bash
# Teste básico
curl http://localhost:8001/

# Teste do microserviço
curl http://localhost:8001/micro_servico

# Ver datasets
curl http://localhost:8001/datasets

# Status do Spark
curl http://localhost:8001/spark/status

# Health check
curl http://localhost:8001/health
```

### Acessar Jupyter
```bash
# Abrir terminal no container
sudo docker exec -it spark-master bash

# Acessar Jupyter via web
# http://localhost:8888
```

## URLs Importantes

- **Jupyter Notebook**: http://localhost:8888
- **Spark Master UI**: http://localhost:8080
- **HDFS NameNode**: http://localhost:9870
- **YARN ResourceManager**: http://localhost:8088
- **API FastAPI**: http://localhost:8001
- **API Swagger**: http://localhost:8001/docs

## Solução de Problemas

### Se a API não funcionar:
```bash
# Ver logs do container
sudo docker logs spark-master

# Reiniciar apenas o master
sudo docker restart spark-master
```

### Se o HDFS não aceitar arquivos:
```bash
# Verificar se o HDFS está formatado
sudo docker exec -it spark-master hdfs namenode -format

# Ou aguardar mais tempo para inicialização
sleep 60
```

### Para executar comandos Spark manualmente:
```bash
# Entrar no container
sudo docker exec -it spark-master bash

# Executar spark-submit
spark-submit --master spark://spark-master:7077 seu_script.py
```
