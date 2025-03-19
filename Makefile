.PHONY: vendor
vendor:
	go mod tidy && go mod vendor

GOOS ?= linux
GOARCH ?= amd64
CGO_ENABLED ?= 0
GIT_URL := $(shell git config --get remote.origin.url)
GIT_COMMIT_HASH := $(shell git rev-parse HEAD)
GIT_BRANCH := $(shell git branch --show-current)
GIT_TAG := $(shell git tag --points-at HEAD)
GIT_TAG := $(or $(GIT_TAG),$(GIT_BRANCH))
BUILD_OS := $(shell uname -rns | sed -e 's/ /_/g') # replace space with _
BUILD_TIME := $(shell date -u +%FT%T%Z)
# GO_MOD_NAME=$(shell go list -m)
GO_APP_INFO_MOD_NAME=github.com/bfi-finance/bfi-go-pkg
# default to static build
GO_BUILD_FLAGS=-trimpath -mod=vendor \
-tags "osusergo,netgo" \
-ldflags "-extldflags=-static -w -s -v \
-X '$(GO_APP_INFO_MOD_NAME)/appinfo.GitURL=$(GIT_URL)' \
-X '$(GO_APP_INFO_MOD_NAME)/appinfo.GitCommitHash=$(GIT_COMMIT_HASH)' \
-X '$(GO_APP_INFO_MOD_NAME)/appinfo.GitTag=$(GIT_TAG)' \
-X '$(GO_APP_INFO_MOD_NAME)/appinfo.BuildTime=$(BUILD_TIME)' \
-X '$(GO_APP_INFO_MOD_NAME)/appinfo.BuildOS=$(BUILD_OS)'"

.PHONY: build
build:
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) go build -x $(GO_BUILD_FLAGS) -o main main.go

.PHONY: run
run:
	docker container run dejanbfi/docker-playground

.PHONY: run/sh
run/sh:
	docker container run -it dejanbfi/docker-playground sh
