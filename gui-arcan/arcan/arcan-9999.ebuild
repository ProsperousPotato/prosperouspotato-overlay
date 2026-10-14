# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Graphical Server"
HOMEPAGE="https://arcan-fe.com"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/letoram/${PN}"
else
	SRC_URI="https://codeberg.org/letoram/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

if [[ ${PV} != "9999" ]]; then
	S="${WORKDIR}/${PN}"
fi

RESTRICT="mirror"

LICENSE="BSD GPL-2+ ZLIB MIT LGPL-2+ OFL-1.1 CC-BY-3.0"
SLOT="0"

IUSE="
	+egl-dri sdl2 egl-gles
	+gl21 gles2 gles3 stub-agp
	hybrid-sdl headless
	+openal
	+jit lwa
	wayland xwayland +xkb
	+lto +simd simd-aligned tracy
	libseat hardened shaping
	libusb v4l
	ffmpeg vlc vnc pdf ocr
	encode decode net remoting +terminal game
	debug
	suid
	X
"

REQUIRED_USE="
	^^ ( egl-dri sdl2 egl-gles )
	^^ ( gl21 gles2 gles3 stub-agp )
	egl-gles? ( || ( gles2 gles3 ) )
	hybrid-sdl? ( egl-dri )
	headless? ( egl-dri )
	simd-aligned? ( simd )
	xwayland? ( wayland )
"

RDEPEND="
	dev-db/sqlite:3
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/mesa
	virtual/opengl
	x11-libs/libdrm
	x11-libs/xcb-util
	ffmpeg? ( media-video/ffmpeg )
	hybrid-sdl? ( media-libs/libsdl2 )
	jit? ( dev-lang/luajit )
	libseat? ( sys-auth/seatd )
	libusb? ( media-libs/libuvc )
	ocr? ( media-libs/leptonica app-text/tesseract )
	openal? ( media-libs/openal )
	pdf? ( app-text/mupdf )
	sdl2? ( media-libs/libsdl2 )
	tracy? ( dev-util/tracy )
	v4l? ( media-video/v4l2loopback )
	vlc? ( || ( media-video/vlc media-libs/libvlc ) )
	vnc? ( net-libs/libvncserver )
	wayland? ( media-libs/harfbuzz[icu] dev-libs/wayland-protocols dev-libs/wayland )
	xkb? ( x11-libs/libxkbcommon )
	X? ( arcan-stuff/Xarcan )
	xwayland? ( x11-base/xwayland )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CMAKE_USE_DIR="${S}/src"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DAUDIO_PLATFORM=$(usex openal openal stub)
		-DVIDEO_PLATFORM=$(usex egl-dri egl-dri $(usex sdl2 sdl2 egl-gles))
		-DAGP_PLATFORM=$(usex gl21 gl21 $(usex gles2 gles2 $(usex gles3 gles3 stub)))

		-DHYBRID_SDL=$(usex hybrid-sdl)
		-DHYBRID_HEADLESS=$(usex headless)

		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DENABLE_WALL_SPAM=OFF
		-DENABLE_SIMD=$(usex simd)
		-DSIMD_ALIGNED=$(usex simd-aligned)
		-DENABLE_LTO=$(usex lto)
		-DENABLE_TRACY=$(usex tracy)

		-DSTATIC_SQLite3=OFF
		-DSTATIC_OPENAL=OFF
		-DSTATIC_LIBUVC=OFF

		-DENABLE_LWA=$(usex lwa)
		-DDISABLE_JIT=$(usex jit off on)
		-DBUILTIN_LUA=$(usex jit off on)

		-DENABLE_LIBSEAT=$(usex libseat)
		-DDISABLE_WAYLAND=$(usex wayland off on)
		-DDISABLE_XKBCOMMON=$(usex xkb off on)
		-DSHMIF_DISABLE_DEBUGIF=$(usex wayland off on)
		-DENABLE_SHAPING=$(usex shaping)

		-DFSRV_TERMINAL_NOEXEC=$(usex hardened)

		-DFSRV_DECODE_UVC=$(usex libusb)
		-DDISABLE_FSRV_ENCODE=$(usex encode off on)
		-DDISABLE_FSRV_DECODE=$(usex decode off on)
		-DDISABLE_FSRV_NET=$(usex net off on)
		-DDISABLE_FSRV_REMOTING=$(usex remoting off on)
		-DDISABLE_FSRV_TERMINAL=$(usex terminal off on)
		-DDISABLE_FSRV_GAME=$(usex game off on)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	if ! use suid; then
		fperms 0755 /usr/bin/arcan
	fi
}
