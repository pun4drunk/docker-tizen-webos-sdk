# Use the base image
FROM vitalets/tizen-webos-sdk

# install gnome-keyring
RUN apt update && apt install -y --no-install-recommends \
    gnome-keyring \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p ~/.cache
RUN mkdir -p ~/.local/share/keyrings

# Copy scripts
COPY ./tizen-package /usr/local/bin/tizen-package
RUN chmod +x /usr/local/bin/tizen-package

# Set default environment variables
ENV SIGN_AUTHOR_CERT="/certificates/author.p12"
ENV SIGN_DISTRIBUTOR_CERT="/certificates/distributor.p12"