# STEP4: BUILD PROD IMAGE
FROM onixldlc/filestash:base AS base
FROM debian:stable-slim AS runner
WORKDIR /app/

RUN apt-get update > /dev/null && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y curl ffmpeg libjpeg-dev libtiff-dev libpng-dev libwebp-dev libraw-dev libheif-dev libgif-dev

# text editors
RUN apt-get install -y emacs vim 
# pdf stuff
RUN apt-get install -y poppler-utils

COPY --from=base /home/filestash/dist/ .

RUN useradd filestash && \
    chown -R filestash:filestash /app/ && \
    find /app/data/ -type d -exec chmod 770 {} \; && \
    find /app/data/ -type f -exec chmod 760 {} \; && \
    chmod 730 /app/filestash && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

USER filestash
CMD ["/app/filestash"]
EXPOSE 8334