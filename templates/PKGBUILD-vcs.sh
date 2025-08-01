# Maintainer: Jax Young <jaxvanyang@gmail.com>
pkgname=NAME-VCS # '-bzr', '-git', '-hg' or '-svn'
_name="${pkgname%-git}"
pkgver=VERSION
pkgrel=1
pkgdesc=""
arch=()
url=""
license=('GPL')
groups=()
depends=()
makedepends=('VCS_PACKAGE') # 'bzr', 'git', 'mercurial' or 'subversion'
provides=("$_name")
conflicts=("$_name")
replaces=()
backup=()
options=()
install=
source=('FOLDER::VCS+URL#FRAGMENT')
noextract=()
sha256sums=('SKIP')

# Please refer to the 'USING VCS SOURCES' section of the PKGBUILD man page for
# a description of each element in the source array.

pkgver() {
	cd "$_name"

# The examples below are not absolute and need to be adapted to each repo. The
# primary goal is to generate version numbers that will increase according to
# pacman's version comparisons with later commits to the repo. The format
# VERSION='VER_NUM.rREV_NUM.HASH', or a relevant subset in case VER_NUM or HASH
# are not available, is recommended.

# Bazaar
	printf "r%s" "$(bzr revno)"

# Git, tags available
	printf "%s" "$(git describe --long | sed 's/\([^-]*-\)g/r\1/;s/-/./g')"

# Git, no tags available
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"

# Mercurial
	printf "r%s.%s" "$(hg identify -n)" "$(hg identify -i)"

# Subversion
	printf "r%s" "$(svnversion | tr -d 'A-z')"
}

prepare() {
	cd "$_name"
	patch -p1 -i "$srcdir/${pkgname%-VCS}.patch"
}

build() {
	cd "$_name"
	./autogen.sh
	./configure --prefix=/usr
	make
}

check() {
	cd "$_name"
	make -k check
}

package() {
	cd "$_name"
	make DESTDIR="$pkgdir/" install
}
