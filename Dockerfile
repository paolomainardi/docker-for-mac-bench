FROM node:18

RUN apt update && apt -y install git && \
    npm install -g npm@latest

WORKDIR /usr/src/app
RUN npx create-react-app . && rm -rf node_modules