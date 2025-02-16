# syntax=docker/dockerfile:1

# Global build arguments.
ARG TEMURIN_VERSION
ARG BASE_IMAGE
ARG BASE_SUFFIX=

# Stage 1: Pull the prebuilt Eclipse Temurin JRE image.
FROM eclipse-temurin:${TEMURIN_VERSION}-jre AS jre

# Stage 2: Use the chosen base image (optionally appending a suffix).
FROM ${BASE_IMAGE}${BASE_SUFFIX}

# Redeclare the build arguments for this stage.
ARG TEMURIN_VERSION
ARG BASE_IMAGE
ARG BASE_SUFFIX

# Output all build argument values for debugging.
RUN echo "=== Build Arguments ===" && \
    echo "TEMURIN_VERSION: ${TEMURIN_VERSION}" && \
    echo "BASE_IMAGE: ${BASE_IMAGE}" && \
    echo "BASE_SUFFIX: ${BASE_SUFFIX}" && \
    echo "Full Base: ${BASE_IMAGE}${BASE_SUFFIX}" && \
    echo "======================="

# Copy the JRE from the Eclipse Temurin image.
COPY --from=jre /opt/java/openjdk /opt/java/openjdk

# Set JAVA_HOME and update PATH.
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify the installation.
CMD ["java", "-version"]
