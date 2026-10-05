# 1. Use a more specific and lighter base image (Alpine)
FROM drupal:10-alpine

# 2. Set the working directory explicitly
WORKDIR /opt/drupal

# 3. Change ownership to run as a non-root user
RUN chown -R www-data:www-data /opt/drupal \
    && chown -R www-data:www-data /var/www/html

# 4. Use a non-root user
USER www-data

# 5. Add a HEALTHCHECK instruction
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1
