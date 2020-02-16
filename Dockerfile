FROM alpine:3.9

COPY main.sh /main.sh

RUN chmod +x /main.sh

ENTRYPOINT ["/main.sh"]
