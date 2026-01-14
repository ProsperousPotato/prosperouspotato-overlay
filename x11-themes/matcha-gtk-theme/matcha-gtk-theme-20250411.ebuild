# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A flat design theme for GTK 3, GTK 2 and GNOME Shell"
HOMEPAGE="https://vinceliuice.github.io/theme-matcha.html"
SRC_URI="https://github.com/vinceliuice/Matcha-gtk-theme/archive/refs/tags/2025-04-11.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	gtk2? (
		x11-themes/gtk-engines-murrine
		x11-themes/gtk-engines
	)
	icons? ( x11-themes/papirus-icon-theme )
"

IUSE="gtk2 icons"

S="${WORKDIR}/Matcha-gtk-theme-2025-04-11"

src_prepare() {
	default

	sed -i "s|GTKSV_DIR=.*|GTKSV_DIR=\"${ED}/usr/share/gtksourceview-3.0/styles\"|" install.sh || die
}

src_install() {
	dodir /usr/share/themes
	./install.sh -d "${ED}/usr/share/themes/" || die "Installation failed"
}
