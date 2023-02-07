FROM moussavdb/build-nodejs:lts as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
RUN git clone --single-branch -b develop https://github.com/yildiz-online/play50hz-web.git
WORKDIR /play50hz-web
RUN yarn
RUN ng build --configuration production

FROM nginx:alpine
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
COPY --from=build /play50hz-web/dist /usr/share/nginx/html
RUN apk add --update curl \
    && rm -rf /var/cache/apk/*
