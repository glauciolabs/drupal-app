---
name: docker-snyk-best-practices
description: >-
  Práticas recomendadas da Snyk para criação de imagens Docker (Node.js, PHP/Drupal, etc.).
  Use esta skill para padronizar e auditar a segurança e performance dos Dockerfiles.
---

# Docker Security Best Practices (Snyk Guidelines)

Esta skill define o padrão de segurança e otimização para a criação de Dockerfiles, baseada no artigo "10 práticas recomendadas de segurança do Docker" da Snyk.

## 1. Imagens Base Mínimas e Determinísticas
- **Sempre utilize imagens mínimas**: Prefira distribuições `-slim` ou `alpine` para reduzir a superfície de ataque e o tempo de download.
- **Use tags explícitas e imutáveis**: Não use `latest` nem tags genéricas (ex: `node` ou `drupal:10`). Prefira tags específicas fixadas com o digest SHA256.
  *Exemplo*: `FROM node:20.9.0-bullseye-slim@sha256:330fa03...` ou `FROM drupal:11.4.8-php8.5-fpm-alpine3.24@sha256:9510b3...`

## 2. Privilégio Mínimo (Não rode como root)
- Contêineres não devem ser executados como root. 
- Use a diretiva `USER` (ex: `USER www-data` ou `USER node`).
- Garanta que as permissões dos arquivos copiados estejam corretas usando `--chown` na cópia ou via `RUN chown`.

## 3. COPY ao invés de ADD
- Nunca use `ADD` para arquivos locais ou URLs (risco de zip slip e ataques MITM). Use sempre `COPY`.
- Evite cópias genéricas `COPY . .` sem um `.dockerignore` bem configurado.

## 4. Multi-stage Builds e Dependências de Produção
- Use `npm ci --only=production` ou similar para instalar apenas pacotes de produção.
- Use compilações em vários estágios (Multi-stage builds) para que ferramentas de build e secrets não vazem para a imagem final.

## 5. Metadata Labels
- Inclua metadados essenciais usando `LABEL` (ex: `maintainer` e arquivo `security.txt`).

## 6. Otimização de Ambiente
- Para Node.js e outras linguagens, defina `ENV NODE_ENV=production` ou `APP_ENV=production` explícita e antecipadamente para otimizar os frameworks.

## 7. Encerramento Seguro (Exec Form)
- Na diretiva `CMD`, use sempre a notação array (Exec form) para iniciar o processo, a fim de garantir o encaminhamento correto dos sinais do sistema operacional (ex: SIGTERM).
  *Correto*: `CMD ["php-fpm"]` ou `CMD ["node", "server.js"]`
  *Incorreto*: `CMD npm start` ou `CMD "php-fpm"`

## 8. Tratamento de Secrets
- Nunca exponha senhas ou chaves SSH via `COPY` ou variáveis de ambiente de compilação.
- Use `RUN --mount=type=secret` para utilizar credenciais de forma segura durante o build.

## Validação e Linting
Recomenda-se o uso de ferramentas como **Hadolint** e varreduras do **Snyk** ou **Trivy** nas esteiras CI/CD para assegurar que essas regras sejam respeitadas.
