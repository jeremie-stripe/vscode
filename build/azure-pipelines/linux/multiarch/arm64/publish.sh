#!/usr/bin/env bash
set -e
REPO="$(pwd)"
ROOT="$REPO/.."

PLATFORM_LINUX="linux-$VSCODE_ARCH"

LEGACY_SERVER_BUILD_NAME="vscode-reh-$PLATFORM_LINUX"
LEGACY_SERVER_BUILD_PATH="$ROOT/$LEGACY_SERVER_BUILD_NAME"
PACKAGEJSON="$LEGACY_SERVER_BUILD_PATH/package.json"
VERSION=$(node -p "require(\"$PACKAGEJSON\").version")

SERVER_BUILD_NAME="vscode-server-$PLATFORM_LINUX"
SERVER_TARBALL_FILENAME="vscode-server-$PLATFORM_LINUX.tar.gz"
SERVER_TARBALL_PATH="$ROOT/$SERVER_TARBALL_FILENAME"

rm -rf $ROOT/vscode-server-*.tar.*
(cd $ROOT && mv $LEGACY_SERVER_BUILD_NAME $SERVER_BUILD_NAME && tar --owner=0 --group=0 -czf $SERVER_TARBALL_PATH $SERVER_BUILD_NAME)

node build/azure-pipelines/common/publish.js "$VSCODE_QUALITY" "server-$PLATFORM_LINUX" archive-unsigned "$SERVER_TARBALL_FILENAME" "$VERSION" true "$SERVER_TARBALL_PATH"
