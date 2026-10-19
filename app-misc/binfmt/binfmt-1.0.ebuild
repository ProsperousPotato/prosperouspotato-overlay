# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Register misc binary formats with the kernel"
HOMEPAGE="https://github.com/OpenRC/openrc"

KEYWORDS="amd64 arm64"
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	!sys-apps/systemd
	!sys-apps/openrc
"

RDEPEND="${DEPEND}"

src_unpack() {
	mkdir -p "${S}" || die
}

src_install() {
	dobin "${FILESDIR}/binfmt"
}
