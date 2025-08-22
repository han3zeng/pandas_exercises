FROM python:3.12-slim

# Create non‑root user "app" with home dir
RUN useradd -m -u 1000 -s /bin/bash app

# Workdir and permissions
WORKDIR /usr/local/app
RUN mkdir -p /usr/local/app/src && chown -R app:app /usr/local/app

# Install deps as root (readable to all users)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir jupyterlab

# Drop privileges
USER app
ENV HOME=/home/app

# Default port for jupyter lab
EXPOSE 8888
VOLUME ["/usr/local/app/src"]
USER app
CMD ["jupyter", "lab", "--notebook-dir=./src", "--no-browser", "--ServerApp.ip=0.0.0.0"]
