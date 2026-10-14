#!/bin/bash
set -eufo pipefail

echo "🚀  Setting up @fernandogcat dotfiles."

os="$(uname -s)"

# When piped from curl, bash reads this script from stdin: anything below that reads stdin
# would swallow the rest of it. Interactive steps read the terminal, the rest reads nothing.
if (exec < /dev/tty) 2>/dev/null; then tty=/dev/tty; else tty=/dev/null; fi

if [ "$os" = "Darwin" ]; then
  if xcode-select -p &> /dev/null; then
    echo "✅  Xcode command line tools are already installed."
  else
    echo "🔧  Installing Xcode command line tools..."
    xcode-select --install &> /dev/null

    while ! xcode-select -p &> /dev/null; do
      sleep 5
    done
    echo "✅  Xcode command line tools installed successfully."
  fi

  if command -v brew &> /dev/null; then
    echo "✅  Homebrew is already installed."
  else
    echo "🍺  Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅  Homebrew installed successfully."
  fi
  export PATH="/opt/homebrew/bin:$PATH"

  if command -v mise &> /dev/null; then
    echo "✅  mise is already installed."
  else
    echo "🧰  Installing mise"
    brew install mise
  fi
else
  echo "🐧  Installing base packages (sudo)"
  sudo apt-get update -qq < /dev/null
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq zsh git curl < /dev/null

  if command -v mise &> /dev/null || [ -x "$HOME/.local/bin/mise" ]; then
    echo "✅  mise is already installed."
  else
    echo "🧰  Installing mise"
    curl -fsSL https://mise.run < /dev/null | sh
  fi
fi

export PATH="$HOME/.local/bin:$PATH"

if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
  echo "ℹ️  Chezmoi already initialized, pulling latest changes..."
  mise x chezmoi -- chezmoi update < "$tty"
  echo "✅  Chezmoi updated"
else
  # Prompts (email, role, ssh key) read the terminal: run this over `ssh -t` on a remote box.
  mise x chezmoi -- chezmoi init --apply fernandogcat < "$tty"
  echo "✅  Chezmoi initialized"
fi

if [ "$os" != "Darwin" ] && [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  echo "🐚  Making zsh the login shell (sudo)"
  sudo chsh -s "$(command -v zsh)" "$(id -un)" < "$tty"
fi

echo "🎉  Done. Open a new terminal."
