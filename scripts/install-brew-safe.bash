set -euo pipefail

RED='\e[38;5;1m'
RESET='\e[0m'

if [[ $(uname -s) != Darwin ]]; then
    echo -e "${RED}Error${RESET}: Do not run this script on the lab machines. Please run this script locally on your MacBook." >&2
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
