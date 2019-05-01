FROM node:11
ENV PORT 8080
WORKDIR /app
COPY package.json /app
RUN npm install
COPY src src/
COPY tests tests/
COPY credentials.json ./credentials.json
CMD npm run start
EXPOSE ${PORT}