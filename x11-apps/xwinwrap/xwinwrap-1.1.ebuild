# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Embed any arbitrary X11 window supporting XEmbed inside the root X11 window"
HOMEPAGE="https://git.adamsucks.me/${PN}/about"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
"

RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" ${PN}
}

src_install() {
	dobin ${PN}
}
