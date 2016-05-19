FROM node:5.10.1-slim

COPY src /root/
WORKDIR /root/src
RUN npm install

EXPOSE 8080
CMD ["node", "/root/src/index.js"]
