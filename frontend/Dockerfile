# --- Stage 1: Build Frontend ---
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build Next.js application
RUN npm run build

# --- Stage 2: Production Image ---
FROM node:20-alpine
WORKDIR /app

# Set environment to production
ENV NODE_ENV=production
ENV NEXT_PUBLIC_API_URL=http://backend:8000

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm install --production

# Copy built application from builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 3000

# Start Next.js production server
CMD ["npm", "run", "start"]
