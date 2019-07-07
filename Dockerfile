FROM golang:1.12 as cache

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# check out & build v1.3.1
RUN go get -d -u github.com/golang/protobuf/protoc-gen-go
RUN git -C $GOPATH/src/github.com/golang/protobuf checkout v1.3.1
RUN go install github.com/golang/protobuf/protoc-gen-go


# create test.proto
RUN echo '\
syntax = "proto2"; \n\
package example; \n\
\n\
enum FOO { X = 17; }; \n\
\n\
message Test { \n\
    required string label = 1; \n\
    optional int32 type = 2 [default=77]; \n\
    repeated int64 reps = 3; \n\
} \n\
' >> ./test.proto

# some debug message
RUN echo "====./test.proto===" && cat ./test.proto && echo "===ls====" && ls -lR && echo "======="

# run a generate command
# but it's said `protoc-gen-go: error:no files to generate`
RUN /go/bin/protoc-gen-go --go_out=. ./test.proto
