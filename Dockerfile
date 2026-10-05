# 1. Use explicit and deterministic tags with SHA256 digest
FROM drupal:11.4.8-php8.5-fpm-alpine3.24@sha256:ce053e5fbd84f236cec759831cb53641160f47f52a41714eeab9cf25752727dd

# 8. Use Metadata labels
LABEL maintainer="glauciolabs"
LABEL securitytxt="https://www.example.com/.well-known/security.txt"

# Set NODE_ENV/APP_ENV if applicable for optimization
ENV APP_ENV=production

# 2. Set the working directory explicitly
WORKDIR /opt/drupal

# 3, 7. Copy files with explicit ownership using COPY instead of ADD
# Assuming there is a composer.json and source code, copy it
# COPY --chown=www-data:www-data composer.json composer.lock ./

# Change ownership of the drupal directories to a non-root user
RUN chown -R www-data:www-data /opt/drupal \
    && chown -R www-data:www-data /var/www/html

# 4. Do not execute containers as root
USER www-data

# 5. Add a HEALTHCHECK instruction
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:9000/ || exit 1

# Safely terminate applications (Exec form)
CMD ["php-fpm"]
