# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="A simple daemon-less notification displayer"
HOMEPAGE="https://git.adamsucks.me/${PN}/about"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"

LICENSE="EUPL-1.1"
SLOT="0"

DEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXft
	media-fonts/terminus-font
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	dobin ${PN}

	save_config config.h
}
