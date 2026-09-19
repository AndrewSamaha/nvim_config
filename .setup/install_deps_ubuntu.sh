#!/usr/bin/env bash
# Install the language servers used by this Neovim configuration on Ubuntu.
#
# Installs:
#   - lua-language-server (LuaLS) to ~/.local/share/lua-language-server
#   - tsgo from @typescript/native-preview using the active npm installation
#
# The wrapper at ~/.local/bin/lua-language-server deliberately executes the
# binary in place: LuaLS needs its bundled files beside the executable.

set -euo pipefail

if [[ ! -r /etc/os-release ]] || ! grep -qx 'ID=ubuntu' /etc/os-release; then
  echo 'This installer is intended for Ubuntu.' >&2
  exit 1
fi

if ! command -v sudo >/dev/null; then
  echo 'sudo is required to install the download prerequisites.' >&2
  exit 1
fi

sudo apt update
sudo apt install --yes ca-certificates curl tar

if ! command -v npm >/dev/null; then
  cat >&2 <<'EOF'
npm was not found. Install a current Node.js release (for example with fnm),
then run this script again. Ubuntu's packaged Node.js may be too old for tsgo.
EOF
  exit 1
fi

case "$(uname -m)" in
  x86_64) lua_ls_arch='linux-x64' ;;
  aarch64|arm64) lua_ls_arch='linux-arm64' ;;
  *)
    echo "Unsupported architecture for the LuaLS release: $(uname -m)" >&2
    exit 1
    ;;
esac

lua_ls_version="$({ curl --fail --silent --show-error --location \
  https://api.github.com/repos/LuaLS/lua-language-server/releases/latest; } \
  | sed -nE 's/.*"tag_name":[[:space:]]*"([^"]+)".*/\1/p' | head -n1)"

if [[ -z "$lua_ls_version" ]]; then
  echo 'Could not determine the latest LuaLS release.' >&2
  exit 1
fi

data_dir="$HOME/.local/share/lua-language-server/$lua_ls_version"
bin_dir="$HOME/.local/bin"
archive_url="https://github.com/LuaLS/lua-language-server/releases/download/$lua_ls_version/lua-language-server-$lua_ls_version-$lua_ls_arch.tar.gz"

mkdir -p "$data_dir" "$bin_dir"
curl --fail --show-error --location "$archive_url" | tar -xz -C "$data_dir"

cat > "$bin_dir/lua-language-server" <<EOF
#!/usr/bin/env bash
exec "$data_dir/bin/lua-language-server" "\$@"
EOF
chmod +x "$bin_dir/lua-language-server"

npm install --global @typescript/native-preview

if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
  cat <<EOF

Add this to your shell startup file, then open a new terminal:
  export PATH="\$HOME/.local/bin:\$PATH"
EOF
fi

echo
echo 'Installed language servers:'
"$bin_dir/lua-language-server" --version
tsgo --version
