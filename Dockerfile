# 1. Етап збірки (Build stage)
FROM node:20-slim AS build

# Активуємо pnpm
RUN corepack enable pnpm

WORKDIR /app

# Копіюємо тільки файли залежностей для кешування
COPY pnpm-lock.yaml package.json ./

# Встановлюємо бібліотеки
RUN pnpm install --frozen-lockfile

# Копіюємо весь інший код і збираємо проєкт
COPY . .
RUN pnpm run build

# 2. Етап запуску (Production stage)
# Використовуємо Nginx, щоб віддавати готові файли
FROM nginx:stable-alpine

# Копіюємо результат збірки з першого етапу в папку Nginx
COPY --from=build /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]