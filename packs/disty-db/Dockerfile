FROM node:8.12.0-alpine

WORKDIR /usr/src/app
COPY package*.json ./
COPY .npmrc ./
RUN npm ci
COPY . .

WORKDIR /usr/src/app
CMD [ "npm", "start" ]
