# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A minimal X application that hides the mouse cursor on keypress, and unhides it on mouse-movement"
HOMEPAGE="https://git.adamsucks.me/${PN}.git/about"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}.git/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXfixes
"

RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	dobin ${PN}
}
