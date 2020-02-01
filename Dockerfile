FROM golang:alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache git

RUN mkdir /app
WORKDIR /app

COPY . .

#ENV CGO_ENABLED=0
RUN echo $GOPATH
RUN pwd
RUN go get
RUN CG0_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-consignment

# Run container
FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app

WORKDIR /app

ADD consignment.json /app/consignment.json

COPY --from=builder /app/shippy-cli-consignment .

CMD ["./shippy-cli-consignment"]