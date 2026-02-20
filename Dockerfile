FROM tensorflow/tensorflow:2.20.0

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

RUN apt-get update && apt-get install -y \
    libxcb1 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libsm6 \
    libglib2.0-0 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock* ./
RUN pip install --no-cache-dir uv && \
    uv sync --frozen --no-dev

COPY . .

EXPOSE 8501

CMD ["uv", "run", "streamlit", "run", "main.py", "--server.address=0.0.0.0"]