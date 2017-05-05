.DEFAULT_GOAL := build
.PHONY: build deploy

VER := $(shell sed -n -e 's/^.\+KAFKA_VERSION\s\+\(.\+\)/\1/p' < Dockerfile)

build:
	docker build -t p4km9y/kafka -t p4km9y/kafka:${VER} .

deploy: build
	docker login
	docker push p4km9y/kafka:${VER}
