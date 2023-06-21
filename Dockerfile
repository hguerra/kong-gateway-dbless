FROM kong:3.3.0-ubuntu

USER root

# https://docs.konghq.com/hub/yesinteractive/kong-jwt2header
# https://github.com/yesinteractive/kong-jwt2header
RUN luarocks install kong-jwt2header

# https://docs.konghq.com/hub/seifchen/kong-path-allow
RUN luarocks install kong-path-allow

# https://github.com/allbarbos/kong-response-cache
RUN luarocks install kong-plugin-response-cache

RUN mkdir -p /opt/kong
COPY kong.yaml /opt/kong/kong.yaml
RUN chown -R kong:kong /opt/kong

# Configuration Reference for Kong Gateway
# https://docs.konghq.com/gateway/latest/production/environment-variables/
# https://docs.konghq.com/gateway/latest/reference/configuration/#general-section
ENV KONG_DATABASE="off"
ENV KONG_PROXY_LISTEN="0.0.0.0:8080"
ENV KONG_ADMIN_LISTEN="0.0.0.0:8001"
ENV KONG_LOG_LEVEL="error"
ENV KONG_ADMIN_ACCESS_LOG="off"
ENV KONG_PROXY_ACCESS_LOG="off"
ENV KONG_PROXY_ERROR_LOG="/dev/stderr"
ENV KONG_ADMIN_ERROR_LOG="/dev/stderr"
ENV KONG_DECLARATIVE_CONFIG="/opt/kong/kong.yaml"
ENV KONG_PLUGINS="bundled,kong-jwt2header,kong-path-allow,response-cache"

# Nginx Directives
# https://docs.konghq.com/gateway/latest/reference/nginx-directives
ENV KONG_NGINX_PROXY_GZIP="on"
ENV KONG_NGINX_PROXY_GZIP_DISABLE="msie6"
ENV KONG_NGINX_PROXY_GZIP_VARY="on"
ENV KONG_NGINX_PROXY_GZIP_PROXIED="any"
ENV KONG_NGINX_PROXY_GZIP_COMP_LEVEL="6"
ENV KONG_NGINX_PROXY_GZIP_BUFFERS="16 8k"
ENV KONG_NGINX_PROXY_GZIP_HTTP_VERSION="1.1"
ENV KONG_NGINX_PROXY_GZIP_MIN_LENGTH="256"
ENV KONG_NGINX_PROXY_GZIP_TYPES="application/atom+xml application/geo+json application/javascript application/x-javascript application/json application/ld+json application/manifest+json application/rdf+xml application/rss+xml application/xhtml+xml application/xml font/eot font/otf font/ttf image/svg+xml text/css text/javascript text/plain text/xml"

USER kong
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8080 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
