# Use Python 3.9 (THIS IS THE KEY)
FROM python:3.9-slim

# Prevent Python from writing pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies (required for dtreeviz)
RUN apt-get update && apt-get install -y \
    graphviz \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for Docker caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose port (Render uses 10000)
EXPOSE 10000

# Start the app
CMD ["gunicorn", "dashboard:server", "--bind", "0.0.0.0:10000"]