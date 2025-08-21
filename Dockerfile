# Stage 1: Build the Jekyll site
FROM jekyll/jekyll:latest as builder
WORKDIR /srv/jekyll
COPY . .
RUN jekyll build

# Stage 2: Serve the static files with Nginx
FROM nginx:alpine
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html
