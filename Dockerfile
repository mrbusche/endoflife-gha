# syntax=docker/dockerfile:1

# Build arguments provided at build time.
ARG TEMURIN_VERSION
ARG BASE_IMAGE

# Stage 1: Pull the prebuilt Eclipse Temurin image.
FROM eclipse-temurin:${TEMURIN_VERSION}-jdk AS jdk

# Stage 2: Use the chosen base image.
FROM ${BASE_IMAGE}

# (Optional) Install required packages if needed.
# For Debian-based images, you might install ca-certificates:
# RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
# For Alpine-based images, you might use:
# RUN apk add --no-cache ca-certificates

# Copy the JDK from the Eclipse Temurin image.
COPY --from=jdk /opt/java/openjdk /opt/java/openjdk

# Set JAVA_HOME and update PATH.
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify installation.
CMD ["java", "-version"]
