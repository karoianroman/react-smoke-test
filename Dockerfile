# 1. Етап збірки (Build stage)
FROM node:20-slim AS build
RUN corepack enable pnpm
WORKDIR /app
COPY pnpm-lock.yaml package.json ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

# 2. Етап запуску (Production stage)
FROM nginx:stable-alpine

# КРОК 1: Змінюємо порт 80 на 8080 у стандартному конфігу Nginx
RUN sed -i 's/listen\(.*\)80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist /usr/share/nginx/html

# КРОК 2: Відкриваємо 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]