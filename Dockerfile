# syntax=docker/dockerfile:1

# Build arguments provided at build time.
ARG TEMURIN_VERSION
ARG DEBIAN_VERSION

# ---------------------------------------
# Stage 1: Pull the prebuilt Eclipse Temurin image.
# Note: TEMURIN_VERSION must be formatted to match the Docker Hub tag,
#       e.g. "11.0.16_8" rather than "11.0.16+8".
FROM eclipse-temurin:${TEMURIN_VERSION}-jdk AS jdk

# ---------------------------------------
# Stage 2: Use the specified Debian image as the base.
FROM debian:${DEBIAN_VERSION}-slim

# Install any minimal packages required (here, we install ca-certificates).
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the installed JDK from the Eclipse Temurin image.
# The official Eclipse Temurin images set JAVA_HOME to /opt/java/openjdk.
COPY --from=jdk /opt/java/openjdk /opt/java/openjdk

# Set up environment variables.
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify the installation.
CMD ["java", "-version"]
