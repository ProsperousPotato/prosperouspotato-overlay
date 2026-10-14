# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs git-r3

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"

EGIT_REPO_URI="git://git.adamsucks.me/${PN}"
IUSE="desktop"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXinerama
	desktop? (
		x11-terms/st
		x11-misc/dmenu
		x11-apps/xhidecursor
		x11-apps/parte
		x11-apps/xset
		x11-misc/hsetroot
		media-gfx/nsxiv
		media-gfx/maim
		media-video/mpv
		net-news/newsboat
		sys-process/htop
		media-sound/alsa-utils
		mail-client/neomutt
		net-p2p/transmission
		app-editors/neovim
		x11-apps/sx
		x11-apps/xrandr
		x11-misc/xclip
		x11-misc/xdotool
	)
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		-e "/^X11LIB/{s:/usr/X11R6/lib:/usr/$(get_libdir)/X11:}" \
		-e '/^X11INC/{s:/usr/X11R6/include:/usr/include/X11:}' \
		config.mk || die

	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" dwm
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	dodoc README

	save_config config.h
}
