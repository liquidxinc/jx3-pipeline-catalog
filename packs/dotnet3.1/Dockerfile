FROM  mcr.microsoft.com/dotnet/core/sdk:3.1-alpine3.10 AS build

# Install tools required to build the project
# We will need to run `docker build --no-cache .` to update those dependencies
RUN apk add --no-cache make curl

# These layers will only be re-built when Gopkg files are updated
RUN mkdir -p /dotnet/src/project
WORKDIR /dotnet/src/project/

# Setup nuget auth
ARG VSS_NUGET_EXTERNAL_FEED_ENDPOINTS
ENV VSS_NUGET_EXTERNAL_FEED_ENDPOINTS=${VSS_NUGET_EXTERNAL_FEED_ENDPOINTS}
ENV NUGET_REPO="Microsoft/artifacts-credprovider"
ENV NUGET_FILE="Microsoft.NuGet.CredentialProvider.tar.gz"
ENV NUGET_VERSION="v0.1.24"
ENV NUGET_URI="https://github.com/${NUGET_REPO}/releases/download/${NUGET_VERSION}/${NUGET_FILE}"
ENV NUGET_PLUGIN_DIR="${HOME}/.nuget/plugins"
RUN mkdir -p "${NUGET_PLUGIN_DIR}"
RUN curl -H "Accept: application/octet-stream" -s -S -L "$NUGET_URI" | tar xz -C "$HOME/.nuget/" "plugins/netcore"

# Copy all project and build it
# This layer will be rebuilt whenever a file has changed in the project directory
COPY . .
RUN make build

# This results in a single layer image
FROM liquidxdev.azurecr.io/alpine:3.12
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
