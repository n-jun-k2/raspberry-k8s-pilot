FROM golang:1.16-buster

ENV GOBIN=${GOPATH}/bin
ENV GO111MODULE=on

RUN go get -u golang.org/x/lint/golint \
    github.com/x-motemen/gobump/cmd/gobump \
    github.com/Songmu/make2help/cmd/make2help \