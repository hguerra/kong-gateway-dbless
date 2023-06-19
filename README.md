# Kong DB-less Example

## Development

```
docker compose up -d redis

make config

make build_docker

make up

make test_health

make test_auth
```
