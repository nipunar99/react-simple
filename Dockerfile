# Specify the base image
FROM node:20.9.0-alpine

WORKDIR /app

#copying package.json and package-lock.json
COPY package.json /app
COPY package-lock.json /app

#installing dependencies
RUN npm ci

#copying source files
COPY . .

#exposing port
EXPOSE 3000

#running the app
CMD ["npm", "start"]

