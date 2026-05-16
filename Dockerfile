# Stage 1: Builder
FROM python:3.11-slim AS builder


WORKDIR /app


# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Copy requirements and build wheels
COPY requirements.txt .


RUN pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt




# Stage 2: Runtime
FROM python:3.11-slim AS deployer

# Create non-root user
RUN useradd -m appuser

WORKDIR /app


# Copy wheels from builder
COPY --from=builder /wheels /wheels

# Install dependencies
RUN pip install --no-cache-dir /wheels/*

# Copy project code
COPY . .

# Change ownership of app files
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Run Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
