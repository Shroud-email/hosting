FROM node:18.4-alpine3.16

ARG version=2.8.28

RUN apk add --no-cache python3 make g++ tini
ENV NODE_ENV production

WORKDIR /app
RUN npm install --global Haraka@${version} --unsafe
COPY ./haraka_config /app/haraka_config

ENTRYPOINT ["/sbin/tini", "--", "haraka", "-c", "/app/haraka_config"]
