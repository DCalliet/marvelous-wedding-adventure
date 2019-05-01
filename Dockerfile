FROM node:11
ENV PORT 8080
WORKDIR /app
COPY package.json /app/package.json
RUN npm install
COPY src /app/src/
COPY tests /app/tests/
COPY credentials.json /app/credentials.json
COPY gapitoken.json /app/gapitoken.json
CMD npm run start
EXPOSE ${PORT}