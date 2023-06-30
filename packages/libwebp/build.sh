TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1c45f135a20c629c31cebcba62e2b399bae5d6e79851aa82ec6686acedcf6f65
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_BREAKS="libwebp-dev"
TERMUX_PKG_REPLACES="libwebp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-libwebpmux
--enable-libwebpdemux
--enable-libwebpdecoder
--enable-libwebpextras
--enable-swap-16bit-csp
--enable-gif
--enable-jpeg
--enable-png
--enable-tiff
--disable-wic
"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=7

	local e=$(sed -En 's/^libwebp_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			src/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./autogen.sh
}
