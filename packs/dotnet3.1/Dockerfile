FROM  mcr.microsoft.com/dotnet/core/sdk:3.1-alpine3.10 AS build

# Install tools required to build the project
# We will need to run `docker build --no-cache .` to update those dependencies
RUN apk add --no-cache make

# These layers will only be re-built when Gopkg files are updated
RUN mkdir -p /dotnet/src/project
WORKDIR /dotnet/src/project/

# Copy all project and build it
# This layer will be rebuilt whenever a file has changed in the project directory
COPY . .
RUN make build

# This results in a single layer image
FROM alpine:3.10
COPY --from=build /dotnet/src/project/bin/project /bin/project
WORKDIR /bin/project

RUN apk update
RUN apk add icu-libs libintl libstdc++

# Uncomment if this app will listen on a non-default URL
# ENV ASPNETCORE_URLS="http://*:8080"

# Uncomment if this app will listen to HTTP requests
EXPOSE 8080

# Separate executable and arguments list
ENTRYPOINT ["/bin/project/REPLACE_ME_APP_NAME"]
