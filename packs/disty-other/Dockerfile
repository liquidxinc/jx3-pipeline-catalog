FROM node:lts-alpine

WORKDIR /usr/src/app
COPY package*.json ./
COPY .npmrc ./
RUN npm ci
COPY . .
EXPOSE 8000

WORKDIR /usr/src/app
CMD [ "npm", "start" ]
