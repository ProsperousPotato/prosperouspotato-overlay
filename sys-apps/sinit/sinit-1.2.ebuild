# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple init program"
HOMEPAGE="https://git.adamsucks.me/${PN}/about
https://git.suckless.org/${PN}/file/README.html
"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"
IUSE="-static"

LICENSE="MIT"
SLOT="0"

DEPEND="
	sys-apps/ubase[init]
	!sys-apps/sysvinit
"

RDEPEND="${DEPEND}"

src_compile() {
	if use static; then
		emake CFLAGS="${CFLAGS} -static" LDFLAGS="${LDFLAGS} -s -static"
	else
		emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS} -s"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	dosym /bin/sinit /sbin/init
}
