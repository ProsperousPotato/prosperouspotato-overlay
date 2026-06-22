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
IUSE="-static"

LICENSE="MIT"
SLOT="0"

DEPEND="
sys-kernel/linux-headers
acct-group/audio
acct-group/cdrom
acct-group/dialout
acct-group/disk
acct-group/floppy
acct-group/input
acct-group/kmem
acct-group/render
acct-group/sgx
acct-group/tape
acct-group/tty
acct-group/usb
acct-group/video
"

RDEPEND="${DEPEND}"

src_prepare() {
	default

	restore_config config.h
}

src_compile() {
	if use static; then
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -static" LDFLAGS="${LDFLAGS} -s -static"
	else
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS} -s"
	fi
}

src_install() {
	dobin ${PN}

	save_config config.h
}
