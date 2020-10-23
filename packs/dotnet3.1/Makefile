OUTPUT_DIR := bin/project
INPUT_DIR := REPLACE_ME_APP_NAME/REPLACE_ME_APP_NAME.csproj

build:
	@echo "Building"
	dotnet publish $(INPUT_DIR) -r linux-musl-x64 -c Release --self-contained=true /p:PublishSingleFile=false -o $(OUTPUT_DIR)

test:
	@echo "Needs a test command"
#	dotnet test ./... -v

test+coverage:
	@echo "Needs a test+coverage command"
#	dotnet test ./... -v -cover -coverprofile=coverprofile.out
# 	dotnet tool cover -html=coverprofile.out -o coverage.html
