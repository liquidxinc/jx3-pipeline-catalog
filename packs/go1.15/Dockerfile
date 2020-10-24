FROM golang:1.15-alpine3.10 AS build

# Install tools required to build the project
# We will need to run `docker build --no-cache .` to update those dependencies
RUN apk update
RUN apk add --no-cache git make

# Uncomment to keyscan github for SSH access; ssh key must be mounted to /root/.ssh
RUN apk add --no-cache openssh
RUN git config --global url."git@github.com:".insteadOf "https://github.com/"
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# These layers will only be re-built when Gopkg files are updated
COPY go.mod /go/src/project/
WORKDIR /go/src/project/

# Copy all project and build it
# This layer will be rebuilt when ever a file has changed in the project directory
COPY . /go/src/project/
RUN make build OUTPUT_DIR=/bin/project
COPY ./swagger-ui /bin/swagger-ui

# This results in a single layer image
FROM alpine:3.10

# Add TLS certs for HTTPS requests
RUN apk update
RUN apk add ca-certificates --no-cache
RUN update-ca-certificates

# Copy binaries over
COPY --from=build /bin/project /bin/project
COPY --from=build /bin/envconsul /bin/envconsul
COPY --from=build /bin/swagger-ui /bin/swagger-ui
WORKDIR /bin

# Uncomment if this app will listen to HTTP requests
EXPOSE 8001

# Separate executable and arguments list
ENTRYPOINT ["/bin/project"]
