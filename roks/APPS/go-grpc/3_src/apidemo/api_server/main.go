/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

//go:generate protoc -I ../helloworld --go_out=plugins=grpc:../helloworld ../helloworld/helloworld.proto

// Package main implements a server for API service.
package main

import (
	"context"
	"log"
	"net"
	"os"
	"fmt"

	"google.golang.org/grpc"
	pb "./apidemo"
)



var 	grcp_port    = "50061"
var 	jsonAPI = "[{\"id\": 1, \"status\": \"OK\", \"ip_address\": \"" + GetOutboundIP() + " \", \"hello\": \"" + os.Getenv("BACKEND_MESSAGE") + "\"}]"

const (



	jsonAPI1 = "test"
)

// server is used to implement helloworld.APIServer.
type server struct {
	pb.UnimplementedAPIServer
}

// SayHello implements helloworld.APIServer
func (s *server) APIGet(ctx context.Context, in *pb.APIRequest) (*pb.APIReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &pb.APIReply{Message: jsonAPI}, nil
}

func (s *server) APIHealth(ctx context.Context, in *pb.APIRequest) (*pb.APIReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &pb.APIReply{Message: "healty"}, nil
}


// Get preferred outbound ip of this machine
func GetOutboundIP() string {
    conn, err := net.Dial("udp", "8.8.8.8:80")
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()

    localAddr := conn.LocalAddr().(*net.UDPAddr)

    return localAddr.IP.String()
}

func main() {

	grpc_port:= os.Getenv("GRPC_PORT")

	lis, err := net.Listen("tcp", ":" + grcp_port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterAPIServer(s, &server{})
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}

	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("  API GRPC SERVER")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("GRPC PORT at: ", grpc_port)
	fmt.Println("------------------------------------------------------------------------------------")

}
