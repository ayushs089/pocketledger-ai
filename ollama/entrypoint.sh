#!/bin/sh
set -eu

MODEL="${OLLAMA_MODEL:-qwen2.5:3b}"

echo "Starting Ollama..."
ollama serve &
OLLAMA_PID=$!

cleanup() {
    kill "$OLLAMA_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "Waiting for Ollama API..."

READY=0
i=0

while [ "$i" -lt 120 ]; do
    if ollama list >/dev/null 2>&1; then
        READY=1
        break
    fi

    if ! kill -0 "$OLLAMA_PID" 2>/dev/null; then
        echo "Ollama exited unexpectedly."
        exit 1
    fi

    i=$((i + 1))
    sleep 2
done

if [ "$READY" -ne 1 ]; then
    echo "Ollama did not become ready in time."
    exit 1
fi

if ! ollama list | awk 'NR > 1 {print $1}' | grep -Fxq "$MODEL"; then
    echo "Downloading model: $MODEL"
    ollama pull "$MODEL"
fi

echo "Model $MODEL is ready."

wait "$OLLAMA_PID"