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


## Reference

### Structured JSON logs:

https://stackoverflow.com/questions/71253184/kong-structured-json-logs

https://docs.konghq.com/gateway/latest/reference/configuration/#proxy_stream_access_log

```
ENV KONG_NGINX_HTTP_LOG_FORMAT="structured_logs escape=json '{\"time\":\"$msec\",\"httpRequest\":{\"requestMethod\":\"$request_method\",\"requestUrl\":\"$scheme://$host$request_uri\",\"requestSize\":\"$request_length\",\"status\":\"$status\",\"responseSize\":\"$bytes_sent\",\"userAgent\":\"$http_user_agent\",\"remoteIp\":\"$http_x_forwarded_for\",\"serverIp\":\"$server_addr\",\"referer\":\"$http_referer\",\"latency\":\"${request_time}s\",\"protocol\":\"$server_protocol\"}}'"

ENV KONG_PROXY_ACCESS_LOG="/dev/stdout structured_logs"
ENV KONG_ADMIN_ACCESS_LOG="/dev/stdout structured_logs"
```
