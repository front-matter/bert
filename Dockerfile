FROM python:3.13-slim

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --frozen --no-install-project --no-dev

COPY api ./api
COPY hypercorn.toml ./
EXPOSE 8090

CMD ["hypercorn", "-b",  "0.0.0.0:8090", "api:app"]