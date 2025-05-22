# Lightweight, Controlled Environment for Running Ollama

A Docker-powered way to run [Ollama](https://ollama.ai)! This project provides a secure, containerized environment for running Ollama with proper resource management and model persistence.

## 🎯 Features

- **Secure Containerization**: Run Ollama in an isolated environment with proper security settings
- **Resource Management**: Control CPU, memory, and process limits
- **Model Persistence**: Keep your models safe between container restarts
- **Easy Management**: Simple npm commands for container control
- **HTTP API Access**: Full access to Ollama's API endpoints
- **Portable**: Run the same setup anywhere Docker is available

## 📋 Prerequisites

- Docker (latest version)
- Node.js (for npm scripts)
- 8GB+ RAM (recommended for larger models)
- 10GB+ free disk space (for models)

## 🛠️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ollama-secure.git
   cd ollama-secure
   ```

2. Build the Docker image:
   ```bash
   npm run docker:build
   ```

## 🚀 Usage

### Container Management

- **Start the container**:
  ```bash
  npm run docker:start
  ```
  This creates a volume and starts Ollama with configured resource limits.

- **View logs**:
  ```bash
  npm run docker:logs
  ```

- **Stop the container**:
  ```bash
  npm run docker:stop
  ```

- **Restart the container**:
  ```bash
  npm run docker:restart
  ```

- **Clean up resources**:
  ```bash
  npm run docker:clean
  ```

### Interactive Usage

1. **Start an interactive chat session**:
   ```bash
   docker exec -it ollama-secure-container ollama run <model-name>
   ```
   Example: `docker exec -it ollama-secure-container ollama run llama2`

2. **List available models**:
   ```bash
   docker exec ollama-secure-container ollama list
   ```

3. **Pull a new model**:
   ```bash
   docker exec ollama-secure-container ollama pull <model-name>
   ```
   Example: `docker exec ollama-secure-container ollama pull gemma:2b`

### HTTP API Usage

The API is available at `http://localhost:11434`. All endpoints accept POST requests with JSON data.

#### 1. Generate Text
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama2",
    "prompt": "Why is the sky blue?"
  }'
```

To get only the response text:
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama2",
    "prompt": "Why is the sky blue?"
  }' | jq -r '.response'
```

#### 2. Chat Completion
```bash
curl -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama2",
    "messages": [
      {
        "role": "user",
        "content": "Hello, how are you?"
      }
    ]
  }'
```

#### 3. List Models
```bash
curl -X POST http://localhost:11434/api/tags
```

#### 4. Pull Model
```bash
curl -X POST http://localhost:11434/api/pull \
  -H "Content-Type: application/json" \
  -d '{"name": "llama2"}'
```

#### 5. Stream Responses
```bash
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama2",
    "prompt": "Tell me a story",
    "stream": true
  }'
```

### Resource Management

The container is configured with the following resource limits:
- Memory: 7GB
- CPU: 2 cores
- Process limit: 100
- Swap: 7GB

To modify these limits, edit the `docker:run` script in `package.json`.

### Model Persistence

Models are stored in a Docker volume named `ollama-models`. This ensures:
- Models persist between container restarts
- Data is isolated from the host system
- Easy backup and management

## 🔧 Configuration

### Environment Variables
- `OLLAMA_HOST=0.0.0.0`: Allows external connections
- `OLLAMA_MODELS=/home/ollama/.ollama`: Model storage location

### Security Features
- Non-root user
- Dropped capabilities
- No new privileges
- Restricted process limits
- Isolated volume storage

## 🐛 Troubleshooting

1. **Container fails to start**:
   - Check Docker logs: `npm run docker:logs`
   - Verify resource availability
   - Ensure port 11434 is not in use

2. **Model loading issues**:
   - Check available memory
   - Verify model name
   - Check volume permissions

3. **API connection issues**:
   - Verify container is running
   - Check port mapping
   - Test with `curl http://localhost:11434/api/tags`

## 📝 License

This project is licensed under the ISC License.

## ⚠️ Notes

- This is a community project, not officially affiliated with Ollama
- Resource limits may need adjustment based on your hardware
- Some models may require more resources than others
- Always verify model compatibility with your system 