FROM golang:alpine
RUN mkdir /app 
RUN apk add git
RUN go get -u google.golang.org/grpc
RUN go get -u github.com/gorilla/mux
ADD main.go /app/
WORKDIR /app 
COPY /apidemo /app/apidemo
RUN go build -o main .
RUN adduser -S -D -H -h /app appuser
USER appuser
ENV GRPC_URL localhost
ENV GRPC_PORT 50061
ENV API_REST_PORT 8090
CMD ["./main"]