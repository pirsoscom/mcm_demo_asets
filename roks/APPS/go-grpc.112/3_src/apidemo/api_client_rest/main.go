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

// Package main implements a client for API service.
package main

import (
	"context"
	"log"
	"os"
	"time"
	"fmt"

	"net/http"
	"github.com/gorilla/mux"

	"google.golang.org/grpc"
	pb "./apidemo"
)

var grpc_server = "localhost:8080"

const (
	address     = "localhost:50061"
	defaultName = "world"
)

func apiGet(w http.ResponseWriter, r *http.Request) {
	response := grpcCallAPIGet("API")
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, response)
}


func grpcCallAPIGet(input string) string {
	// Set up a connection to the server.
	fmt.Println("Connecting to ", grpc_server)

	conn, err := grpc.Dial(grpc_server, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewAPIClient(conn)

	// Contact the server and print out its response.
	name := input
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.APIGet(ctx, &pb.APIRequest{Name: name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetMessage())
	return r.GetMessage()
}




func apiHealth(w http.ResponseWriter, r *http.Request) {
	response := grpcCallAPIHealth("Health")
	fmt.Fprintf(w, response)
}

func grpcCallAPIHealth(input string) string {
	// Set up a connection to the server.
	fmt.Println("Connecting to ", grpc_server)

	conn, err := grpc.Dial(grpc_server, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewAPIClient(conn)

	// Contact the server and print out its response.
	name := input
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.APIHealth(ctx, &pb.APIRequest{Name: name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetMessage())
	return r.GetMessage()
}

func main() {
	grpc_url := os.Getenv("GRPC_URL")
	grpc_port:= os.Getenv("GRPC_PORT")
	grpc_server = grpc_url + ":" + grpc_port
	rest_port:= os.Getenv("API_REST_PORT")


	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/get", apiGet)
	router.HandleFunc("/health", apiHealth)


	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("  API REST CLIENT")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("Exposed APIs")
	fmt.Println("  /get")
	fmt.Println("  /health")
	fmt.Println("------------------------------------------------------------------------------------")
	fmt.Println("GRPC SERVER at: ", grpc_server)
	fmt.Println("REST SERVER at ", rest_port)
	fmt.Println("------------------------------------------------------------------------------------")


	log.Fatal(http.ListenAndServe(":" + rest_port, router))


}