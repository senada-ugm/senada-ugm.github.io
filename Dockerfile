# ============================================================
# Stage 1: Build Jekyll site
# ============================================================
FROM ruby:3.2-slim AS builder

# Install system dependencies for Jekyll and native gems
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    libffi-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll

# Copy Gemfile first for caching
COPY Gemfile Gemfile.lock* ./

# Install bundler and gems
RUN gem install bundler -v "~> 2.4" && \
    bundle config set --local force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the project
COPY . .

# Build the Jekyll site
RUN bundle exec jekyll build --verbose

# ============================================================
# Stage 2: Serve with Nginx
# ============================================================
FROM nginx:1.25-alpine

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy built site from builder stage
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html

# Copy custom nginx config (optional, fallback to default)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
