# =========================
# Stage 1: Build Stage
# =========================
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies first (for caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application
COPY . .

# Build the Next.js app
RUN npm run build

# =========================
# Stage 2: Production Stage
# =========================
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built app and dependencies from builder
COPY --from=builder /app ./

# Install only production dependencies
RUN npm ci --omit=dev

# Expose Next.js default port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
