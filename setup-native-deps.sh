#!/usr/bin/env bash
# BisimNet: fetch the native libraries the audio engine needs (run once, from the project root).
# Needs git + internet access. GitLab sources may require a VPN depending on your network.
set -e
cd "$(dirname "$0")/libraries/humla"
get() { # url path commit
  if [ -d "$2/.git" ] || [ -n "$(ls -A "$2" 2>/dev/null)" ]; then echo "skip $2 (already present)"; return; fi
  mkdir -p "$2"; git clone "$1" "$2"; (cd "$2" && git checkout -q "$3"); echo "ok   $2"
}
get https://github.com/xiph/opus                 src/main/jni/opus               65471dd567beb6b1156dc292858c0a28ca55ca3e
get https://github.com/xiph/speex                src/main/jni/speex              a6d05eb5ff9d5062852cdf7df574bec728921ef9
get https://gitlab.com/quite/celt.git            src/main/jni/celt-0.11.0-src    e3d39fec7c44d1841e817d3b1986bfdc4d0863a9
get https://gitlab.com/quite/celt.git            src/main/jni/celt-0.7.0-src     6c79a9325c328f86fa048bf124ff6a8912a60a3e
get https://gitlab.com/quite/humla-spongycastle.git libs/humla-spongycastle      12e49a233023855a9f58651a70bbe7e24bfd5f39 || {
  echo "GitLab unreachable, trying the GitHub copy of the same branch (verify it builds)"
  rm -rf libs/humla-spongycastle; git clone -b pkcs12-keybag-fixes https://github.com/Morlunk/spongycastle libs/humla-spongycastle; }
echo "Done. Open this folder in Android Studio."
