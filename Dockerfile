FROM alpine:3.9

RUN apk update && apk add bash git npm jq

COPY main.sh /main.sh

RUN chmod +x /main.sh

ENTRYPOINT ["/main.sh"]
