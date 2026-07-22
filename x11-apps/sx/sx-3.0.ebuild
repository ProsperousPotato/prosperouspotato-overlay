# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Start an xorg server"
HOMEPAGE="https://www.github.com/Earnestly/sx"

RESTRICT="mirror"

SRC_URI="https://github.com/Earnestly/${PN}/archive/refs/tags/${PV}.tar.gz"
KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="
	x11-apps/xauth
	|| ( x11-base/xorg-server x11-base/xlibre-server )
"

RDEPEND="${DEPEND}"

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
