FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
RUN git clone --single-branch -b master https://github.com/yildiz-online/play50hz-web.git

FROM moussavdb/build-nodejs as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/play50hz-web /app
RUN yarn
RUN ng build --prod

FROM nginx:alpine
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /app/dist /usr/share/nginx/html
RUN apk add --update curl \
    && rm -rf /var/cache/apk/*
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
