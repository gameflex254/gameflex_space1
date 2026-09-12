FROM oven/bun:1.2.15-alpine AS build

WORKDIR /app

COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

COPY . .
RUN bun run build

FROM node:22-alpine AS runner

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=8080

WORKDIR /app

COPY --from=build /app/dist ./dist

EXPOSE 8080

USER node

CMD ["node", "dist/server/index.mjs"]