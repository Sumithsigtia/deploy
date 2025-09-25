# Stage 1: build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first for caching
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: production image
FROM node:18-alpine

WORKDIR /app

# Copy built files from builder
COPY --from=builder /app ./

# Install only production dependencies
RUN npm install --production

EXPOSE 3000

CMD ["npm", "start"]
