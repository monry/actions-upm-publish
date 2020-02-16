FROM alpine:3.9

RUN sudo apt-get update && sudo apt-get install jq

COPY main.sh /main.sh

RUN chmod +x /main.sh

ENTRYPOINT ["/main.sh"]
