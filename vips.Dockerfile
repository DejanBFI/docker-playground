FROM buildpack-deps:bookworm AS vips-builder

ARG LIBVIPS_VERSION=8.16.1

RUN apt update && apt install --yes --no-install-recommends python3 python3-pip python3-setuptools \
    python3-wheel ninja-build scons patchelf pipx
ENV PATH="/root/.local/bin:$PATH"
RUN pipx install meson && pipx install staticx
RUN wget https://github.com/libvips/libvips/archive/refs/tags/v${LIBVIPS_VERSION}.tar.gz
RUN tar xf v${LIBVIPS_VERSION}.tar.gz && rm -rf v${LIBVIPS_VERSION}.tar.gz
WORKDIR /libvips-${LIBVIPS_VERSION}
RUN meson setup build --libdir lib --prefix /libvips-${LIBVIPS_VERSION}/local
WORKDIR /libvips-${LIBVIPS_VERSION}/build
RUN meson compile
RUN meson test
RUN meson install
# Bundle all executables
RUN staticx /libvips-${LIBVIPS_VERSION}/local/bin/vips /usr/bin/vips && \
    staticx /libvips-${LIBVIPS_VERSION}/local/bin/vipsedit /usr/bin/vipsedit && \
    # staticx /libvips-${LIBVIPS_VERSION}/local/bin/vipsheader /usr/bin/vipsheader && \ # commented due to error: invalid ELF image
    staticx /libvips-${LIBVIPS_VERSION}/local/bin/vipsthumbnail /usr/bin/vipsthumbnail

CMD ["/bin/sh"]
