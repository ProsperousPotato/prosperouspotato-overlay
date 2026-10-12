# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="QPA plugin for Arcan"
HOMEPAGE="https://codeberg.org/vimpostor/${PN}"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/vimpostor/qtarcan.git"
	KEYWORDS=""
else
	SRC_URI="https://codeberg.org/vimpostor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}"
fi

RESTRICT="mirror"
LICENSE="|| ( LGPL-3 GPL-2 GPL-3 )"
SLOT="0"

DEPEND="
	dev-qt/qtbase:6=[gui,opengl]
	arcan-stuff/arcan
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DTARGET_QT_VERSION=6
		-DQT_PLUGIN_PREFIX="$(get_libdir)/qt6/plugins/platforms"
	)
	cmake_src_configure
}

pkg_postinst() {
	ewarn "Feel free to use this patch for qtbase to automatically run qt applications under arcan"
	ewarn "otherwise, you should set QT_QPA_PLATFORM=arcan\n"

	elog "diff --git a/src/gui/kernel/qguiapplication.cpp b/src/gui/kernel/qguiapplication.cpp"
	elog "index aef1f538716..1d09ab73f9d 100644"
	elog "--- a/src/gui/kernel/qguiapplication.cpp"
	elog "+++ b/src/gui/kernel/qguiapplication.cpp"
	elog "@@ -1550,6 +1550,14 @@ void QGuiApplicationPrivate::createPlatformIntegration()"
	elog "             platformName.clear();"
	elog "     }"
	elog " "
	elog "+    const bool defaultIsArcan = platformPluginBase == \"arcan\";"
	elog "+    const QByteArray arcanPlatformName = defaultIsArcan ? platformName : \"arcan\";"
	elog "+    if (qEnvironmentVariableIsSet(\"ARCAN_CONNPATH\") || qEnvironmentVariableIsSet(\"ARCAN_SOCKIN_FD\")) {"
	elog "+        preferredPlatformOrder << arcanPlatformName;"
	elog "+        if (defaultIsArcan)"
	elog "+            platformName.clear();"
	elog "+    }"
	elog "+"
	elog "     if (!platformName.isEmpty())"
	elog "         preferredPlatformOrder.append(platformName);"
}
