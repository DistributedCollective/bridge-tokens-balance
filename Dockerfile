FROM node:12-alpine AS base

WORKDIR /app

# ---------- Builder ----------
# Creates:
# - node_modules: production dependencies (no dev dependencies)
FROM base AS builder

COPY package*.json ./

RUN npm install

COPY ./ ./


# Remove dev dependencies
RUN npm prune --production

# ---------- Release ----------
FROM base AS release

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/* .

USER node

# TODO if works in production without port remove this line
# EXPOSE 3000

CMD ["node", "./checkBalances.js"]
