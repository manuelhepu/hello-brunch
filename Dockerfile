FROM node:lts-buster as nodebuild
WORKDIR /build/
COPY package.json yarn.lock /build/
RUN yarn
COPY ./ /build/
RUN yarn build


FROM nginx
COPY --from=nodebuild /build/public/ /usr/share/nginx/html/
