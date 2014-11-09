PROJECT ?= abevoelker/nginx
VERSION ?= mainline
TAG     ?= latest

ifdef REGISTRY
  IMAGE=$(REGISTRY)/$(PROJECT):$(TAG)
else
  IMAGE=$(PROJECT):$(TAG)
endif

all:
	@echo "Available targets:"
	@echo "  * build - build a Docker image for $(IMAGE)"
	@echo "  * pull  - pull down previous docker builds of $(IMAGE)"

build:
	cd $(VERSION) && docker build -t $(IMAGE) .

pull:
	docker pull $(IMAGE) || true
