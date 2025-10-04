# Use nginx as a lightweight production web server
FROM nginx:stable-alpine

# Copy your built app (dist folder) to nginx's default html folder
COPY dist /usr/share/nginx/html

# Copy custom nginx configuration (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 3000
EXPOSE 3000

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

