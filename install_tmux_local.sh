#!/bin/bash
# ============================================================================
# Local tmux installer (no root/sudo required)
# ============================================================================
# Compiles tmux and its dependencies from source into your home directory.
# Useful for shared servers, HPC clusters, or systems without root access.
#
# Requirements: wget, gcc/g++ (C/C++ compiler), make
# Result: tmux installed at $HOME/local/bin/tmux
# ============================================================================

set -e  # Exit on error

# Configuration - modify these as needed
TMUX_VERSION="3.4"
LIBEVENT_VERSION="2.1.12-stable"
NCURSES_VERSION="6.4"
INSTALL_DIR="$HOME"

# Derived paths
LOCAL_DIR="$INSTALL_DIR/local"
TMP_DIR="$INSTALL_DIR/tmux_build_tmp"
BIN_DIR="$LOCAL_DIR/bin"

echo "=== Local tmux installer ==="
echo "Installing tmux $TMUX_VERSION to $BIN_DIR"
echo ""

# Create directories
mkdir -p "$LOCAL_DIR" "$TMP_DIR"
cd "$TMP_DIR"

# ============================================================================
# Download source files
# ============================================================================
echo ">>> Downloading source files..."

wget -q --show-progress -O "tmux-${TMUX_VERSION}.tar.gz" \
    "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"

wget -q --show-progress -O "libevent-${LIBEVENT_VERSION}.tar.gz" \
    "https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}/libevent-${LIBEVENT_VERSION}.tar.gz"

wget -q --show-progress -O "ncurses-${NCURSES_VERSION}.tar.gz" \
    "https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz"

# ============================================================================
# Build libevent
# ============================================================================
echo ""
echo ">>> Building libevent ${LIBEVENT_VERSION}..."
tar xzf "libevent-${LIBEVENT_VERSION}.tar.gz"
cd "libevent-${LIBEVENT_VERSION}"
./configure --prefix="$LOCAL_DIR" --disable-shared --quiet
make -j$(nproc) --quiet
make install --quiet
cd ..

# ============================================================================
# Build ncurses
# ============================================================================
echo ">>> Building ncurses ${NCURSES_VERSION}..."

# Check for AFS filesystem (needs symlinks enabled)
NCURSES_OPTS=""
if command -v fs &> /dev/null && [[ $(fs --version 2>/dev/null) =~ "afs" ]]; then
    NCURSES_OPTS="--enable-symlinks"
fi

tar xzf "ncurses-${NCURSES_VERSION}.tar.gz"
cd "ncurses-${NCURSES_VERSION}"
./configure --prefix="$LOCAL_DIR" $NCURSES_OPTS --quiet
make -j$(nproc) --quiet
make install --quiet
cd ..

# ============================================================================
# Build tmux
# ============================================================================
echo ">>> Building tmux ${TMUX_VERSION}..."
tar xzf "tmux-${TMUX_VERSION}.tar.gz"
cd "tmux-${TMUX_VERSION}"

./configure \
    CFLAGS="-I$LOCAL_DIR/include -I$LOCAL_DIR/include/ncurses" \
    LDFLAGS="-L$LOCAL_DIR/lib -L$LOCAL_DIR/include/ncurses" \
    CPPFLAGS="-I$LOCAL_DIR/include -I$LOCAL_DIR/include/ncurses" \
    --quiet

make -j$(nproc) --quiet
cp tmux "$BIN_DIR/"
cd ..

# ============================================================================
# Cleanup
# ============================================================================
echo ">>> Cleaning up..."
rm -rf "$TMP_DIR"

# ============================================================================
# Done
# ============================================================================
echo ""
echo "=== Installation complete ==="
echo "tmux ${TMUX_VERSION} installed at: $BIN_DIR/tmux"
echo ""
echo "To use it, add this to your .bashrc or .zshrc:"
echo "  export PATH=\"\$HOME/local/bin:\$PATH\""
echo ""
echo "Then run: tmux -V"
