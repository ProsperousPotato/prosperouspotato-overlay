# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple init program written in zig"
HOMEPAGE="https://git.adamsucks.me/init/about/"

RESTRICT="mirror"

SRC_URI="https://git.adamsucks.me/${PN}/snapshot/${PN}-${PV}.tar.xz"
KEYWORDS="amd64"

ZIG_SLOT="0.16"

inherit zig savedconfig

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	sys-apps/ubase[init]
	!sys-apps/sysvinit
	|| (
		>=dev-lang/zig-0.16
		>=dev-lang/zig-bin-0.16
	)
"

src_prepare() {
	zig_src_prepare

	restore_config config.zig
}

src_install() {
	zig build -p "${EPREFIX}"/usr

	insinto /etc
	newins rc rc
	newins shutdown shutdown

	dobin ${S}/poweroff
	dobin ${S}/reboot

	save_config config.zig
}
