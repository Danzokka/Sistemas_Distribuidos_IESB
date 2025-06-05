from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
import subprocess
import os
import json
from datetime import datetime

app = FastAPI(
    title="Laboratório 6 - API de Análise de Texto",
    description="API para processamento de dados textuais com PySpark no cluster Hadoop/Spark",
    version="1.0.0"
)

@app.get("/")
async def root():
    """Endpoint de teste básico"""
    return {
        "message": "Hello World",
        "service": "Laboratório 6 - Sistemas Distribuídos IESB",
        "timestamp": datetime.now().isoformat(),
        "status": "online"
    }

@app.get("/micro_servico")
async def microservico():
    """Endpoint do microserviço de processamento"""
    try:
        # Aqui você pode executar scripts Python específicos
        # subprocess.run(["python3", "script_requerido.py"])
        
        return {
            "message": "rodou o microserviço com sucesso!",
            "timestamp": datetime.now().isoformat(),
            "service": "processamento_texto",
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro no microserviço: {str(e)}")

@app.get("/health")
async def health_check():
    """Verificação de saúde do serviço"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "services": {
            "hdfs": "running",
            "spark": "running",
            "yarn": "running"
        }
    }

@app.get("/datasets")
async def list_datasets():
    """Lista os datasets disponíveis no HDFS"""
    try:
        # Executar comando HDFS para listar arquivos
        result = subprocess.run(
            ["hdfs", "dfs", "-ls", "/datasets/"],
            capture_output=True,
            text=True,
            cwd="/user_data"
        )
        
        if result.returncode == 0:
            # Processar a saída do comando
            files = []
            for line in result.stdout.split('\n'):
                if '.txt' in line:
                    parts = line.split()
                    if len(parts) >= 8:
                        files.append({
                            "name": parts[-1].split('/')[-1],
                            "path": parts[-1],
                            "size": parts[4],
                            "date": f"{parts[5]} {parts[6]}"
                        })
            
            return {
                "datasets": files,
                "count": len(files),
                "timestamp": datetime.now().isoformat()
            }
        else:
            raise HTTPException(status_code=500, detail="Erro ao acessar HDFS")
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao listar datasets: {str(e)}")

@app.get("/spark/status")
async def spark_status():
    """Status do cluster Spark"""
    return {
        "master": "spark://spark-master:7077",
        "web_ui": "http://localhost:8080",
        "status": "running",
        "timestamp": datetime.now().isoformat()
    }