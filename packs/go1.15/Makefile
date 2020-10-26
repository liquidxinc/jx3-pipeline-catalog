OUTPUT_DIR := bin/project

# Decides whether to build a swagger API or a standard Go project
ifneq (,$(wildcard swagger/swagger.yml))
MAIN_GO := ./gen/cmd/server
build: build-swagger build-binary
else
MAIN_GO := ./
build: build-binary
endif

build-swagger:
	mkdir -p ./gen
	swagger generate server -f ./swagger/swagger.yml --main-package server -t ./gen

build-binary:
	go build -o $(OUTPUT_DIR) $(MAIN_GO)

test:
	go test ./... -v

test+coverage:
	go test ./... -v -cover -coverprofile=coverprofile.out
	go tool cover -html=coverprofile.out -o coverage.html
