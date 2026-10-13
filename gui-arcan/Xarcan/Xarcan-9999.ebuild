# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic xorg-meson

DESCRIPTION="X server that runs X11 programs under arcan"
HOMEPAGE="https://arcan-fe.com"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/letoram/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://codeberg.org/letoram/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

IUSE="lto"

if [[ ${PV} != "9999" ]]; then
	S="${WORKDIR}/${PN,,}"
fi



RESTRICT="mirror"

SLOT="0"

DEPEND="
	gui-arcan/arcan
	app-alternatives/lex
	dev-libs/expat
	dev-libs/libbsd
	media-libs/libepoxy[X]
	media-libs/libglvnd[X]
	media-libs/mesa[X]
	x11-apps/iceauth
	x11-apps/xkbcomp
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXfont2
	x11-libs/libdrm
	x11-libs/libpciaccess
	x11-libs/libxcb
	x11-libs/libxcvt
	x11-libs/libxkbcommon[X]
	x11-libs/libxkbfile
	x11-libs/libxshmfence
	x11-libs/pixman
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xtrans
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	use x86 && replace-flags -Os -O2
	use x86 && replace-flags -Oz -O2

	local XORG_CONFIGURE_OPTIONS=(
		--localstatedir "${EPREFIX}/var"
		--sysconfdir "${EPREFIX}/etc/X11"
		-Dxarcan=true
		-Dbuildtype=release
		-Ddebug=false
		-Db_ndebug=true
		-Ddri1=true
		-Ddri2=true
		-Ddri3=true
		-Ddrm=true
		-Dglamor=true
		-Dglx=true
		-Ddocs=false
		-Ddtrace=false
		-Dipv6=false
		-Dhal=false
		-Dlinux_acpi=false
		-Dlinux_apm=false
		-Dsha1=libcrypto
		-Dxkb_output_dir="${EPREFIX}/var/lib/xkb"
		-Dsystemd_logind=false
		-Dsystemd_notify=false
		-Dsuid_wrapper=false
		-Dxdmcp=false
		-Dxwayland=false
	)

	if use lto; then
		XORG_CONFIGURE_OPTIONS+=(
			-Db_lto=true
		)
	fi

	xorg-meson_src_configure
}

src_install() {
	xorg-meson_src_install

	rm -f "${ED}/usr/share/man/man1/Xserver.1"
	rm -f "${ED}/usr/lib64/xorg/protocol.txt"
}
