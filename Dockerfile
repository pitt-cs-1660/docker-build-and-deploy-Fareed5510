# The Builing stage
FROM golang:1.23 AS build

WORKDIR /app

# The copy source files
COPY go.mod ./
COPY main.go ./
COPY templates ./templates

# Builds the static binary which is required for scratch image
RUN CGO_ENABLED=0 go build -o app .

# The Final stage
FROM scratch

WORKDIR /app

# Copies and compiles binary and templates
COPY --from=build /app/app /app/app
COPY --from=build /app/templates /app/templates

# App will run on port 8080
EXPOSE 8080

CMD ["/app/app"]
