PROJECT  ?= abevoelker/nginx

ifdef REGISTRY
  IMAGE=$(REGISTRY)/$(PROJECT)
else
  IMAGE=$(PROJECT)
endif

all:
	@echo "Available targets:"
	@echo "  * build - build a Docker image for $(IMAGE)"
	@echo "  * pull  - pull down previous docker builds of $(IMAGE)"

build: Dockerfile
	docker build -t $(IMAGE) .

pull:
	docker pull $(IMAGE) || true
