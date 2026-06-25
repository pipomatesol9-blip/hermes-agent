FROM ghcr.io/nousresearch/hermes-agent:latest

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
