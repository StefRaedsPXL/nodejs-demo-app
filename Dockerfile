# --- Stage 1: Build Stage ---
FROM node:20-alpine AS build

# Set working directory
WORKDIR /usr/src/app

# Copy package files first (better caching)
COPY package*.json ./

# Install all dependencies (needed for build/test)
RUN npm install

# Copy the rest of the application code
COPY . .

# --- Stage 2: Production Image ---
FROM node:20-alpine AS production

WORKDIR /usr/src/app

# Copy only necessary files from build stage
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy app source from build stage
COPY --from=build /usr/src/app ./

# Set environment variables
ENV NODE_ENV=production
ENV PORT=5000

# Expose the application port
EXPOSE 5000

# Start the Node.js server
CMD ["npm", "start"]
