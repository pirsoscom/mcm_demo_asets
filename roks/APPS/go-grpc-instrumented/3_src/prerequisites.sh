

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-osx-x86_64.zip
unzip protoc-3.11.4-osx-x86_64.zip
mv bin/protoc /usr/local/bin
mv include/* /usr/local/include


brew install golang

go get -u google.golang.org/grpc
go get -u github.com/golang/protobuf/protoc-gen-go

export PATH=$PATH:$GOPATH/bin



go get -u github.com/gorilla/mux



export BACKEND_MESSAGE="Hello from the Backend"
export GRPC_URL=localhost
export GRPC_PORT=50061
export API_REST_PORT=8090
export BACKEND_URL=localhost:8090


curl localhost:8090/health
curl localhost:8090/get