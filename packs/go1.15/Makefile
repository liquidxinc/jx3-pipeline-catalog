OUTPUT_DIR := bin/project
MAIN_GO := ./

build:
	go build -o $(OUTPUT_DIR) $(MAIN_GO)

test:
	go test ./... -v

test+coverage:
	go test ./... -v -cover -coverprofile=coverprofile.out
	go tool cover -html=coverprofile.out -o coverage.html
