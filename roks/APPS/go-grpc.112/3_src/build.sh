

protoc -I apidemo/ apidemo/apidemo.proto --go_out=plugins=grpc:apidemo

go run api_client_rest/main.go
go run api_server/main.go

go build -o api_client_rest/api api_client_rest/main.go

go build -o server api_server/main.go
go build -o api api_client_rest/main.go



# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
# CREATE SERVER
# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
cd api_server
docker build -t niklaushirt/grpc-server:1.0.0 .
docker push niklaushirt/grpc-server:1.0.0



# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
# CREATE API CLIENT
# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
docker build -t niklaushirt/grpc-api:1.0.0 .
docker push niklaushirt/grpc-api:1.0.0


# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------
# CREATE WEB
# ------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------

docker build -t niklaushirt/grpc-web:1.0.0 ./grpc-web
docker push niklaushirt/grpc-web:1.0.0




docker run --name grpc-server --rm -d -p 50061:50061 niklaushirt/grpc-server:1.0.0 
docker run --name grpc-rest-api --rm -d -e GRPC_URL=0.0.0.0 -p 8091:8090 niklaushirt/grpc-api:1.0.0
docker run --name grpc-web --rm -d -p 3000:3000 niklaushirt/grpc-web:1.0.0 
