FROM busybox:1.37.0-uclibc AS busybox

# Build Go file
FROM golang:1.23.7-bookworm AS builder
RUN apt update && apt install --yes libvips libvips-dev libvips-tools
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
RUN ldconfig
RUN pkg-config --cflags --libs vips
WORKDIR /go/src/builder
COPY . .
RUN make vendor
RUN make build

# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/base-debian12:nonroot
# Copy busybox sh and tee required by entrypoint.sh
COPY --from=busybox /bin/sh /bin/sh
COPY --from=busybox /bin/tee /bin/tee
COPY --from=busybox /bin/ls /bin/ls
# Copy the server binary
COPY --from=builder /go/src/builder/main /app/main
# Copy the libvips binaries and libs
COPY --from=builder /usr/lib/aarch64-linux-gnu/libvips* /usr/lib/aarch64-linux-gnu/
COPY --from=builder /usr/lib/aarch64-linux-gnu/libgio-2.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libgmodule-2.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libz.so.1 \
                    /usr/lib/aarch64-linux-gnu/libgsf-1.so.114 \
                    /usr/lib/aarch64-linux-gnu/libfftw3.so.3 \
                    /usr/lib/aarch64-linux-gnu/libcfitsio.so.10 \
                    /usr/lib/aarch64-linux-gnu/libimagequant.so.0 \
                    /usr/lib/aarch64-linux-gnu/libcgif.so.0 \
                    /usr/lib/aarch64-linux-gnu/libexif.so.12 \
                    /usr/lib/aarch64-linux-gnu/libwebpmux.so.3 \
                    /usr/lib/aarch64-linux-gnu/libwebpdemux.so.2 \
                    /usr/lib/aarch64-linux-gnu/libpango-1.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libcairo.so.2 \
                    /usr/lib/aarch64-linux-gnu/libpangoft2-1.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libfontconfig.so.1 \
                    /usr/lib/aarch64-linux-gnu/librsvg-2.so.2 \
                    /usr/lib/aarch64-linux-gnu/libmatio.so.11 \
                    /usr/lib/aarch64-linux-gnu/libOpenEXR-3_1.so.30 \
                    /usr/lib/aarch64-linux-gnu/libopenjp2.so.7 \
                    /usr/lib/aarch64-linux-gnu/liborc-0.4.so.0 \
                    /usr/lib/aarch64-linux-gnu/libpcre2-8.so.0 \
                    /usr/lib/aarch64-linux-gnu/libmount.so.1 \
                    /usr/lib/aarch64-linux-gnu/libselinux.so.1 \
                    /usr/lib/aarch64-linux-gnu/libxml2.so.2 \
                    /usr/lib/aarch64-linux-gnu/libbz2.so.1.0 \
                    /usr/lib/aarch64-linux-gnu/libcurl-gnutls.so.4 \
                    /usr/lib/aarch64-linux-gnu/libgomp.so.1 \
                    /usr/lib/aarch64-linux-gnu/libharfbuzz.so.0 \
                    /usr/lib/aarch64-linux-gnu/libfribidi.so.0 \
                    /usr/lib/aarch64-linux-gnu/libthai.so.0 \
                    /usr/lib/aarch64-linux-gnu/libpixman-1.so.0 \
                    /usr/lib/aarch64-linux-gnu/libfreetype.so.6 \
                    /usr/lib/aarch64-linux-gnu/libvips.so.42 \
                    /usr/lib/aarch64-linux-gnu/libpangocairo-1.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libxcb-shm.so.0 \
                    /usr/lib/aarch64-linux-gnu/libxcb.so.1 \
                    /usr/lib/aarch64-linux-gnu/libxcb-render.so.0 \
                    /usr/lib/aarch64-linux-gnu/libXrender.so.1 \
                    /usr/lib/aarch64-linux-gnu/libX11.so.6 \
                    /usr/lib/aarch64-linux-gnu/libXext.so.6 \
                    /usr/lib/aarch64-linux-gnu/libzstd.so.1 \
                    /usr/lib/aarch64-linux-gnu/liblzma.so.5 \
                    /usr/lib/aarch64-linux-gnu/libLerc.so.4 \
                    /usr/lib/aarch64-linux-gnu/libjbig.so.0 \
                    /usr/lib/aarch64-linux-gnu/libdeflate.so.0 \
                    /usr/lib/aarch64-linux-gnu/libcairo-gobject.so.2 \
                    /usr/lib/aarch64-linux-gnu/libgdk_pixbuf-2.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libgcc_s.so.1 \
                    /usr/lib/aarch64-linux-gnu/libhdf5_serial.so.103 \
                    /usr/lib/aarch64-linux-gnu/libImath-3_1.so.29 \
                    /usr/lib/aarch64-linux-gnu/libIlmThread-3_1.so.30 \
                    /usr/lib/aarch64-linux-gnu/libIex-3_1.so.30 \
                    /usr/lib/aarch64-linux-gnu/libstdc++.so.6 \
                    /usr/lib/aarch64-linux-gnu/libblkid.so.1 \
                    /usr/lib/aarch64-linux-gnu/libicuuc.so.72 \
                    /usr/lib/aarch64-linux-gnu/libnghttp2.so.14 \
                    /usr/lib/aarch64-linux-gnu/libidn2.so.0 \
                    /usr/lib/aarch64-linux-gnu/librtmp.so.1 \
                    /usr/lib/aarch64-linux-gnu/libssh2.so.1 \
                    /usr/lib/aarch64-linux-gnu/libpsl.so.5 \
                    /usr/lib/aarch64-linux-gnu/libnettle.so.8 \
                    /usr/lib/aarch64-linux-gnu/libgnutls.so.30 \
                    /usr/lib/aarch64-linux-gnu/libgssapi_krb5.so.2 \
                    /usr/lib/aarch64-linux-gnu/libldap-2.5.so.0 \
                    /usr/lib/aarch64-linux-gnu/liblber-2.5.so.0 \
                    /usr/lib/aarch64-linux-gnu/libbrotlidec.so.1 \
                    /usr/lib/aarch64-linux-gnu/libgraphite2.so.3 \
                    /usr/lib/aarch64-linux-gnu/libdatrie.so.1 \
                    /usr/lib/aarch64-linux-gnu/libXau.so.6 \
                    /usr/lib/aarch64-linux-gnu/libXdmcp.so.6 \
                    /usr/lib/aarch64-linux-gnu/libcurl.so.4 \
                    /usr/lib/aarch64-linux-gnu/libsz.so.2 \
                    /usr/lib/aarch64-linux-gnu/libicudata.so.72 \
                    /usr/lib/aarch64-linux-gnu/libunistring.so.2 \
                    /usr/lib/aarch64-linux-gnu/libhogweed.so.6 \
                    /usr/lib/aarch64-linux-gnu/libgmp.so.10 \
                    /usr/lib/aarch64-linux-gnu/libp11-kit.so.0 \
                    /usr/lib/aarch64-linux-gnu/libtasn1.so.6 \
                    /usr/lib/aarch64-linux-gnu/libkrb5.so.3 \
                    /usr/lib/aarch64-linux-gnu/libk5crypto.so.3 \
                    /usr/lib/aarch64-linux-gnu/libcom_err.so.2 \
                    /usr/lib/aarch64-linux-gnu/libkrb5support.so.0 \
                    /usr/lib/aarch64-linux-gnu/libsasl2.so.2 \
                    /usr/lib/aarch64-linux-gnu/libbrotlicommon.so.1 \
                    /usr/lib/aarch64-linux-gnu/libbsd.so.0 \
                    /usr/lib/aarch64-linux-gnu/libaec.so.0 \
                    /usr/lib/aarch64-linux-gnu/libkeyutils.so.1 \
                    /usr/lib/aarch64-linux-gnu/libmd.so.0 \
                    /usr/lib/aarch64-linux-gnu/libgobject-2.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libglib-2.0.so.0 \
                    /usr/lib/aarch64-linux-gnu/libexpat.so.1 \
                    /usr/lib/aarch64-linux-gnu/libjpeg.so.62 \
                    /usr/lib/aarch64-linux-gnu/libpng16.so.16 \
                    /usr/lib/aarch64-linux-gnu/libwebp.so.7 \
                    /usr/lib/aarch64-linux-gnu/libtiff.so.6 \
                    /usr/lib/aarch64-linux-gnu/liblcms2.so.2 \
                    /usr/lib/aarch64-linux-gnu/libffi.so.8 \
    /usr/lib/aarch64-linux-gnu/
COPY --from=builder /usr/bin/vips* /usr/bin/
WORKDIR /app
# Copy image. Even though it's not efficient, this is only for testing.
COPY image.jpg /app/image.jpg
CMD ["./main"]
