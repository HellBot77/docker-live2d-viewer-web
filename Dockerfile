FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/guansss/live2d-viewer-web.git && \
    cd live2d-viewer-web && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git && \
    rm yarn.lock && \
    wget -P public https://cubism.live2d.com/sdk-web/cubismcore/live2dcubismcore.min.js

FROM node:alpine AS build

WORKDIR /live2d-viewer-web
COPY --from=base /git/live2d-viewer-web .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /live2d-viewer-web/dist .
