FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
WORKDIR /app
RUN git clone --single-branch -b nolock https://github.com/yildiz-online/play50hz-web.git

FROM node:18-alpine as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/play50hz-web /app
RUN yarn --network-timeout 100000 install
RUN ng build --configuration production

FROM nginx:alpine
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /app/dist /usr/share/nginx/html
RUN apk add --update curl \
    && rm -rf /var/cache/apk/*
