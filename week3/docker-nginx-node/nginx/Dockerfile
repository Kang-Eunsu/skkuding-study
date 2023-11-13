FROM nginx:latest

COPY index.html /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx