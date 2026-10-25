# 1. Use explicit and deterministic tags with SHA256 digest
FROM drupal:11.4.8-php8.5-apache-bookworm@sha256:dea8cf332565624cfa96df65500e3ee657d8223d206108f2c839c1505374cbaf

# 8. Use Metadata labels
LABEL org.opencontainers.image.source="https://github.com/glauciolabs/drupal-app" \
      org.opencontainers.image.description="Drupal application image"

# Set NODE_ENV/APP_ENV if applicable for optimization
ENV APP_ENV=production

# 2. Set the working directory explicitly
WORKDIR /opt/drupal

# 3, 7. Copy files with explicit ownership using COPY instead of ADD
# Assuming there is a composer.json and source code, copy it
# COPY --chown=www-data:www-data composer.json composer.lock ./

# The official Apache entrypoint manages its web-server process and privilege
# drop. No package manager or build tooling is added to runtime.
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD php -r 'exit((int) !@file_get_contents("http://127.0.0.1/"));'
