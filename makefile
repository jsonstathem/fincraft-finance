.PHONY: test generate-mocks generate-proto

PROTO_DIR := ./api
PROTO_OUT := ./api

# Проверил только на Windows, надеюсь на Linux тоже будет работать :)
generate-proto:
ifeq ($(OS),Windows_NT)
	powershell -Command "$$protoPath = Resolve-Path $(PROTO_DIR); Get-ChildItem -Recurse $(PROTO_DIR) -Filter *.proto | ForEach-Object { protoc --proto_path=$$protoPath --go_out=$(PROTO_OUT) --go-grpc_out=$(PROTO_OUT) $$_.FullName.Replace('\\', '/') }"
else
	find $(PROTO_DIR) -name "*.proto" -exec protoc --proto_path=$(PROTO_DIR) --go_out=$(PROTO_OUT) --go-grpc_out=$(PROTO_OUT) {} +
endif

generate-mocks:
	go generate ./...

test: generate-mocks generate-proto
	go test ./...

test-sum: generate-mocks generate-proto
	gotestsum --format short-verbose ./...
