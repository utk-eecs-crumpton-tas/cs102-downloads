set -euo pipefail

if [[ $(uname -s) != Darwin ]]; then
    echo "This script is only for macOS" >&2
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
