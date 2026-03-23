FROM golang:1.24-alpine AS build
WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /out/test-cicd-app ./main.go

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/test-cicd-app /app

EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/app"]
