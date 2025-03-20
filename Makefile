.PHONY: vendor
vendor:
	go mod tidy && go mod vendor

.PHONY: build
build:
	go build -o main main.go

.PHONY: run
run:
	docker container run dejanbfi/docker-playground

.PHONY: run/sh
run/sh:
	docker container run -it dejanbfi/docker-playground sh
