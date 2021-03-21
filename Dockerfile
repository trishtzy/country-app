FROM node:14.16.0 AS build-env

WORKDIR /app

COPY package.json ./

RUN npm install

FROM node:14.16.0-alpine
WORKDIR /app
COPY --from=build-env /app ./
COPY . /app

EXPOSE 8000

ENTRYPOINT ["npm", "run", "serve"]
