.PHONY: vendor
vendor:
	go mod tidy && go mod vendor

.PHONY: build
build:
	docker build -t dejanbfi/docker-playground .

.PHONY: run
run:
	docker container run dejanbfi/docker-playground

.PHONY: run/sh
run/sh:
	docker container run -it dejanbfi/docker-playground sh
