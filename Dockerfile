# STEP1: BUILD FRONTEND
FROM node:18-alpine AS builder_frontend
COPY . /home/filestash/
WORKDIR /home/filestash/
RUN apk add make git gzip brotli && \
    npm install --legacy-peer-deps && \
    make build_frontend && \
    cd public && make compress

# STEP2: BUILD BACKEND
FROM golang:1.23-bookworm AS builder_backend
WORKDIR /home/filestash/
COPY --from=builder_frontend /home/filestash/ .
RUN apt-get update > /dev/null && \
    apt-get install -y curl make > /dev/null 2>&1 && \
    apt-get install -y libjpeg-dev libtiff-dev libpng-dev libwebp-dev libraw-dev libheif-dev libgif-dev libvips-dev > /dev/null 2>&1 && \
    make build_init && \
    make build_backend && \
    mkdir -p ./dist/data/state/config/ && \
    cp config/config.json ./dist/data/state/config/config.json

# STEP3: BUILD BASE IMAGE
FROM debian:stable-slim
COPY --from=builder_backend /home/filestash/ /home/filestash/
