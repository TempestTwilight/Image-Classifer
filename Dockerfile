# Start from official TensorFlow image (has Python + TF ready)
FROM tensorflow/tensorflow:latest   # or :latest-gpu if you need GPU

# Optional: set these for better uv behavior in containers
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Work inside /app
WORKDIR /app

# Copy just the dependency files first → Docker caches this layer
COPY pyproject.toml uv.lock* ./

# Install uv (if not already in the base image) + sync dependencies
# --frozen = don't update lockfile, just use it
# --no-dev  = skip dev dependencies (good for production image)
RUN pip install --no-cache-dir uv && \
    uv sync --frozen --no-dev

# Now copy your actual code
COPY main.py .   # or whatever your script is called

# If your script needs data/models, copy them too, e.g.:
# COPY data/ ./data/

# Run your script
CMD ["uv", "run", "streamlit", "run", "main.py"]
# or just CMD ["python", "app.py"] if you prefer (uv venv is activated)