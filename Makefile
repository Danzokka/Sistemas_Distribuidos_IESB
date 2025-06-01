.PHONY: build

build:
	@docker build -t danzokka/spark-base-hadoop ./hadoop/spark-base
	@docker build -t danzokka/spark-master-hadoop ./hadoop/spark-master
	@docker build -t danzokka/spark-worker-hadoop ./hadoop/spark-worker