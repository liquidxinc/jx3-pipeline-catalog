FROM liquidxdev.azurecr.io/golang:1.15-alpine3.12 AS build

# Install tools required to build the project
# We will need to run `docker build --no-cache .` to update those dependencies
RUN apk update
RUN apk add --no-cache git make

# Uncomment to keyscan github for SSH access; ssh key must be mounted to /root/.ssh
ARG SSH_PRIVATE_KEY
RUN apk add --no-cache openssh
RUN git config --global url."git@github.com:".insteadOf "https://github.com/"
RUN mkdir -p /root/.ssh
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# These layers will only be re-built when Gopkg files are updated
COPY go.mod /go/src/project/
WORKDIR /go/src/project

# Copy all project and build it
# This layer will be rebuilt when ever a file has changed in the project directory
RUN wget -O /usr/local/bin/swagger "https://github.com/go-swagger/go-swagger/releases/download/v0.25.0/swagger_linux_amd64"
RUN chmod +x /usr/local/bin/swagger
COPY Makefile .
COPY src src
COPY Makefile swagger* swagger/
COPY Makefile gen* gen/
ENV GOPRIVATE=github.com/liquidxinc
RUN make build

# This results in a single layer image
FROM liquidxdev.azurecr.io/alpine:3.12

# Add TLS certs for HTTPS requests
RUN apk update
RUN apk add ca-certificates --no-cache
RUN update-ca-certificates

# Copy binaries over
COPY --from=build /go/src/project/bin/project /bin/project

# Uncomment if this app will listen to HTTP requests
EXPOSE 8001

# Separate executable and arguments list
ENTRYPOINT ["/bin/project"]
