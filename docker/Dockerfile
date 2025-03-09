FROM node:18-alpine

WORKDIR /app

COPY app.js /app

RUN npm install ip

ENV PORT=1234

EXPOSE $PORT

CMD ["node", "app.js"]