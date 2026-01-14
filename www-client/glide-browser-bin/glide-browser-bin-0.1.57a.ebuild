# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg


DESCRIPTION="An extensible and keyboard-focused web browser"
HOMEPAGE="https://github.com/glide-browser/glide"
SRC_URI="
	amd64? ( https://github.com/glide-browser/glide/releases/download/${PV}/glide.linux-x86_64.tar.xz -> ${P}-x86_64.tar.xz )
	arm64? ( https://github.com/glide-browser/glide/releases/download/${PV}/glide.linux-aarch64.tar.xz -> ${P}-aarch64.tar.xz )
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="X -wayland"
RESTRICT="strip"

BDEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
    !www-client/glide-browser-bin:0
    || (
        media-libs/libpulse
        media-sound/apulse
    )
    >=app-accessibility/at-spi2-core-2.46.0:2
    >=dev-libs/glib-2.26:2
    media-libs/alsa-lib
    media-libs/fontconfig
    >=media-libs/freetype-2.4.10
    media-video/ffmpeg
    sys-apps/dbus
    virtual/freedesktop-icon-theme
    >=x11-libs/cairo-1.10[X]
    x11-libs/gdk-pixbuf:2
    >=x11-libs/gtk+-3.11:3[X,wayland?]
    x11-libs/libX11
    x11-libs/libXcomposite
    x11-libs/libXcursor
    x11-libs/libXdamage
    x11-libs/libXext
    x11-libs/libXfixes
    x11-libs/libXi
    x11-libs/libXrandr
    x11-libs/libXrender
    x11-libs/libxcb
    >=x11-libs/pango-1.22.0
"


S="${WORKDIR}/glide"

QA_PREBUILT="opt/glide-browser-bin/*"

src_install() {
	local destdir="/opt/${PN}"

	insinto "${destdir}"
	doins -r ./*

	fperms 0755 "${destdir}/glide-bin"

	if [[ -f "${ED}${destdir}/glide" ]]; then
		fperms 0755 "${destdir}/glide"
	fi

	cat > "${T}/glide-bin" <<-EOF || die
		#!/bin/bash
		exec "/opt/${PN}/glide-bin" "\$@"
	EOF

	dobin "${T}/glide-bin"

	make_desktop_entry \
		"/usr/bin/glide-bin %u" \
		"Glide Browser" \
		"glide-bin" \
		"Network;WebBrowser;" \
		"StartupWMClass=Glide Browser\nMimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https;"

	local size
	for size in 16 32 48 64 128; do
		newicon -s ${size} \
			"${ED}${destdir}/browser/chrome/icons/default/default${size}.png" \
			glide-bin.png
	done
}

pkg_postrm() {
	xdg_pkg_postrm
}
