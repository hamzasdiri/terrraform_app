FROM node:21-slim
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY  . /app/
EXPOSE 3000
ENV PORT=3000
CMD [ "node", "/app/index.js" ]