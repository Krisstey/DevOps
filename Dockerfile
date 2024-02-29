FROM ubuntu:22.04 as builder
WORKDIR /opt/app

RUN apt-get update &&  \
    apt-get install -y \
      rubygems \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install yaml-cv
COPY cv.yaml cv.yaml
RUN yaml-cv cv.yaml --html cv.html

FROM nginx:latest as release
WORKDIR /opt/app
COPY --from=builder /opt/app/cv.html /usr/share/nginx/html/index.html
VOLUME /opt/app