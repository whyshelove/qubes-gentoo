# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
inherit eutils distutils-r1 qubes git-r3

Q=qubes-core-vchan
if [[ ${PV} == *9999 ]]; then
	inherit qubes
	EGIT_COMMIT=HEAD
	Q_PN=${Q}-xen
	EGIT_REPO_URI="https://github.com/QubesOS/${Q_PN}.git"
	S=$WORKDIR/${Q_PN}
else
	inherit rpm
	MY_PR=${PVR##*r}
	MY_P=qubes-${PN}-xen-${PV}
	SRC_URI="${REPO_URI}/${MY_P}-${MY_PR}.${DIST}.src.rpm"
	S=$WORKDIR/${MY_P}
fi

QS_PN=${Q}-socket
EGIT_COMMIT=HEAD
EGIT_REPO_URI="https://github.com/QubesOS/${QS_PN}.git"
SS=$WORKDIR/${QS_PN}

KEYWORDS="amd64"
DESCRIPTION="QubesOS libvchan cross-domain communication library"
HOMEPAGE="http://www.qubes-os.org"
LICENSE="GPLv2"

SLOT="0"
IUSE="socket"

DEPEND="app-emulation/xen-tools"
RDEPEND="${DEPEND}"
PDEPEND=""

pkg_setup() {
	CFLAGS="${CFLAGS:--O2 -g}" ; export CFLAGS ; 
  	CXXFLAGS="${CXXFLAGS:--O2 -g}" ; export CXXFLAGS ; 
  	FFLAGS="${FFLAGS:--O2 -g }" ; export FFLAGS ; 
  	FCFLAGS="${FCFLAGS:--O2 -g }" ; export FCFLAGS ; 
  	LDFLAGS="${LDFLAGS:-}" ; export LDFLAGS

	export LIBDIR=/usr/$(get_libdir)
	export INCLUDEDIR=/usr/include
}

src_unpack() {
	rpm_src_unpack ${A}
	use socket && git clone ${EGIT_REPO_URI}
}

src_compile() {
	emake all
	use socket && cd $SS && emake all
}

src_install() {
	emake DESTDIR=${D} install
	use socket && cd $SS && emake DESTDIR=${D} install
}
