FROM debian:stable

# Create working directories
RUN mkdir -p /src /out /toolchains /ccache
WORKDIR /src

COPY build.sh .

RUN ./build.sh

# Copy toolchain files
COPY toolchains/*.cmake /toolchains/

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Environment setup
ENV PATH="/usr/local/bin:${PATH}"
ENV SOURCE_DIR="/src"
ENV BUILD_DIR="/out"
ENV CCACHE_DIR="/ccache"

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
