FROM ollama/ollama:latest

WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENV OLLAMA_HOST=0.0.0.0:11434 \
    OLLAMA_KEEP_ALIVE=5m

EXPOSE 11434

ENTRYPOINT ["/app/entrypoint.sh"]