# Stage 1: Build the node modules
FROM node:12-alpine as builder
ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache

# Stage 2: Build the final image
FROM node:12-alpine
ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR
COPY --from=builder /usr/src/app/node_modules node_modules
# Ensure the user 'node' owns the node_modules directory
RUN chown $USER:$USER $WORKDIR/node_modules
# Copy the application files and change ownership to non-root user 'node'
COPY --chown=node . $WORKDIR

# Add 'wizexercise.txt' to the Docker image
COPY --chown=node wizexercise.txt $WORKDIR

# Security configurations
# In production environment uncomment the next line
# RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR

# Switch to non-root user for security
USER $USER

# Expose port 4000 for the application
EXPOSE 4000
