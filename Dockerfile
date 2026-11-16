FROM nginx:1.27-alpine

ARG GIT_SHA=local
ARG BUILD_TIME=unknown

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY app/ /usr/share/nginx/html/

RUN sed -i "s/__GIT_SHA__/${GIT_SHA}/; s/__BUILD_TIME__/${BUILD_TIME}/" /usr/share/nginx/html/index.html

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz || exit 1

EXPOSE 80
