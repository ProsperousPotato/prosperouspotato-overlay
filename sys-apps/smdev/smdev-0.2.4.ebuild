# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

DESCRIPTION="A (mostly) mdev-compatible program to manage device nodes."
HOMEPAGE="https://git.adamsucks.me/${PN}/about
https://git.suckless.org/smdev/file/README.html
"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="sys-kernel/linux-headers"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}

	save_config config.h
}
