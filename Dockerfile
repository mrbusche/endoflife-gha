# syntax=docker/dockerfile:1

# Global build arguments.
ARG TEMURIN_VERSION
ARG BASE_IMAGE

# Stage 1: Pull the prebuilt Eclipse Temurin image.
FROM eclipse-temurin:${TEMURIN_VERSION}-jdk AS jdk

# Stage 2: Use the specified base image.
FROM ${BASE_IMAGE}

# Redeclare the build arguments for this stage.
ARG TEMURIN_VERSION
ARG BASE_IMAGE

# Output all build argument values for debugging.
RUN echo "=== Build Arguments ===" && \
    echo "TEMURIN_VERSION: ${TEMURIN_VERSION}" && \
    echo "BASE_IMAGE: ${BASE_IMAGE}" && \
    echo "======================="

# Copy the JDK from the Eclipse Temurin image.
COPY --from=jdk /opt/java/openjdk /opt/java/openjdk

# Set up environment variables.
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify the installation.
CMD ["java", "-version"]
