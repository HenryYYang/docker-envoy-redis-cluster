FROM envoyproxy/envoy-dev:latest

RUN apt-get update -qq && apt-get install -yqq redis-tools curl dnsutils

ADD envoy.yaml /etc/envoy/envoy.yaml

EXPOSE 6380

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]