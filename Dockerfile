############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

WORKDIR /go/src/app
COPY . .

RUN go get -d -v

# Build the binary.
#RUN go build -o /go/bin/app
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/app

############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/app /go/bin/app
# Run the hello binary.
ENTRYPOINT ["/go/bin/app"]