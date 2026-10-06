# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Suckless linux base utils"
HOMEPAGE="https://git.suckless.org/${PN}/file/README.html
https://git.adamsucks.me/${PN}/about
"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"
IUSE="+init +su static login selinux"
REQUIRED_USE="|| ( init su login )"

LICENSE="MIT"
SLOT="0"

DEPEND=""

RDEPEND="${DEPEND}
	selinux? ( sys-libs/libselinux )
	init? ( !sys-apps/sysvinit )
	su? ( !sys-apps/shadow[su] !sys-apps/util-linux[su] )
	static? ( virtual/libcrypt[static-libs] )
	login? ( !sys-apps/shadow[login] )
"

zbase_bin() {
	local b=""
	use init && b+="killall5 getty halt respawn "
	use su && b+="su "
	use login && b+="login "
	echo "${b}"
}

src_compile() {
	if use static; then
		emake CFLAGS="${CFLAGS} -static" LDFLAGS="${LDFLAGS} -s -static" BIN="$(zbase_bin)"
	else
		emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS} -s" BIN="$(zbase_bin)"
	fi
}

src_install() {
	local man1="" man8=""
	use init && man8+="killall5.8 getty.8 halt.8 "
	use init && man1+="respawn.1 "
	use su && man1+="su.1 "
	use login && man1+="login.1 "

	emake BIN="$(zbase_bin)" MAN8="${man8}" MAN1="${man1}" DESTDIR="${D}" PREFIX=/usr install
}
