# ============================================
# Dockerfile — Tino Paul Portfolio
# Base: nginx:alpine (lightweight web server)
# ============================================

FROM nginx:alpine

# Copy website files into Nginx's default serving directory
COPY . /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Nginx starts automatically with the base image's default CMD
