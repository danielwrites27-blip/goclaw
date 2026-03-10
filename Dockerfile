FROM golang:1.26-alpine AS builder

WORKDIR /build

COPY . .

RUN CGO_ENABLED=0 GOTOOLCHAIN=local go build -ldflags="-s -w" -o goclaw .

FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata bash curl

WORKDIR /app

COPY --from=builder /build/goclaw /app/goclaw

RUN chmod +x /app/goclaw

EXPOSE 18790

CMD ["/app/goclaw"]
