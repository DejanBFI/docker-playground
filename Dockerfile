FROM busybox:1.37.0-uclibc AS busybox

# Build Go file
FROM golang:1.23.7-bookworm AS builder
RUN apt update && apt install --yes libvips libvips-dev libvips-tools
WORKDIR /go/src/builder
COPY . .
RUN go mod tidy && go mod vendor
RUN go build -o main main.go

# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/base-debian12:nonroot
# Copy busybox sh and tee required by entrypoint.sh
COPY --from=busybox /bin/sh /bin/sh
COPY --from=busybox /bin/tee /bin/tee
# Copy the server binary
COPY --from=builder /go/src/builder/main /app/main
# Copy the libvips binaries and libs
COPY --from=builder /usr/lib /usr/lib
COPY --from=vips-builder /usr/bin/vips* /usr/bin/
WORKDIR /app
# Copy image. Even though it's not efficient, this is only for testing.
COPY image.jpg /app/image.jpg
CMD ["./main"]
