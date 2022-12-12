FROM node:18-alpine

RUN apk add --no-cache git && \
    npm install -g npm@latest

WORKDIR /usr/src/app
RUN npx create-react-app . && rm -rf node_modules