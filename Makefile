.PHONY: config

install:
	mkdir -p ./bin ./tmp
	curl -L https://github.com/hguerra/envsubst/releases/download/v1.0.6/envsubst_linux_amd64 -o bin/envsubst && chmod +x bin/envsubst
	curl -L https://github.com/grafana/k6/releases/download/v0.45.0/k6-v0.45.0-linux-amd64.tar.gz -o tmp/k6.tar.gz && tar -xzvf tmp/k6.tar.gz --directory tmp/ && rm -rf tmp/*.tar.gz && mv tmp/*/k6 bin && chmod +x bin/k6
	rm -rf ./tmp

config:
	bin/envsubst -no-empty < configs/kong-template.yaml > kong.yaml

clean:
	rm -f kong.yaml

# https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/
# https://docs.konghq.com/gateway/latest/install/docker/
build_docker:
	docker build --network host -t heitorcarneiro/kong:3.3.0-ubuntu .

build: clean config build_docker

up: config
	docker compose up -d
	docker compose logs -f kong

down: clean
	docker compose down
	docker compose rm -f

restart: config
	docker compose restart kong
	docker compose logs -f kong

test_unauthorized_health:
	curl -i -X GET http://localhost:8080/gateway/health/status

test_health:
	curl -i -X GET http://localhost:8080/gateway/health/status?auth_token=xyz

test_gzip:
	curl --compressed -i -X GET http://localhost:8080/gateway/health/status?auth_token=xyz -H 'Accept-Encoding: gzip'

test_path_not_allowed:
	curl -i -X GET http://localhost:8080/gateway/health/mypath?auth_token=xyz

test_auth:
	curl -i -X GET http://localhost:8080/mock/request -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImlhdCI6MTY4NzM0ODA2MSwiZXhwIjoxNjg3MzQ4NjYxLCJzdWIiOiJjZGE2NDAxMS00N2E4LTRhNmEtOGFhYy0wNmM3ZGI2ZmM1OTMiLCJnaXZlbl9uYW1lIjoiSGVpdG9yIiwiZmFtaWx5X25hbWUiOiJDYXJuZWlybyIsImVtYWlsIjoiaGVpdG9yQGV4YW1wbGUuY29tIiwicm9sZXMiOlsidmlld2VyIiwiYWNjZXNzYXBwcm92YWwuYXBwcm92ZXIiXX0.43ls0r5E2SSx1ted0ItVLXOWG5IPT08xp81uIVbea9M'

test_performance:
	bin/k6 run test/performance.test.js

test_serve:
	npx serve test
