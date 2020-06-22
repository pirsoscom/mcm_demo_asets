FROM golang:alpine
RUN mkdir /app 
RUN apk add git
RUN go get -u google.golang.org/grpc
ADD main.go /app/
WORKDIR /app 
COPY /apidemo /app/apidemo
RUN go build -o main .
RUN adduser -S -D -H -h /app appuser
USER appuser
ENV BACKEND_MESSAGE "Hello from the Backend"
ENV GRPC_PORT 50061
CMD ["./main"]