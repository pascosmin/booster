#!/usr/bin/env bash
# Sound Boost installer — installs deps, makes script executable, adds 'boost' alias

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOST_PATH="$SCRIPT_DIR/boost"
ALIAS_LINE="alias boost='python3 $BOOST_PATH &'"

echo "==> Installing system dependencies..."
sudo apt-get install -y python3 python3-tk swh-plugins

echo "==> Making boost executable..."
chmod +x "$BOOST_PATH"

echo "==> Adding 'boost' alias to ~/.bashrc..."
if grep -qF "alias boost=" ~/.bashrc; then
    echo "    (alias already present, skipping)"
else
    echo "" >> ~/.bashrc
    echo "# Sound Boost launcher" >> ~/.bashrc
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "    Done. Run: source ~/.bashrc"
fi

echo ""
echo "All done! Type 'boost' in a terminal to launch Sound Boost."
