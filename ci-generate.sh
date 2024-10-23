#!/bin/bash
OPENSSL_VERSION="$1"
FW_PATH="$2"

# Set the directory where liboqs will be downloaded and built
LIBOQS_DIR="$(pwd)/liboqs"

# Clone and build liboqs if not already present
if [ ! -d "$LIBOQS_DIR" ]; then
  echo "Cloning and building liboqs..."
  git clone --branch main https://github.com/open-quantum-safe/liboqs.git "$LIBOQS_DIR"
  cd "$LIBOQS_DIR"
  cmake -S . -B build
  cmake --build build
  cd ..
fi

echo "Compiling OpenSSL $OPENSSL_VERSION"
export LDFLAGS="-L$LIBOQS_DIR/build/lib"
export CPPFLAGS="-I$LIBOQS_DIR/build/include"

# Build OpenSSL with liboqs support
./build-libssl.sh --cleanup --version="$OPENSSL_VERSION" --with-oqs

# Create OpenSSL framework
./create-openssl-framework.sh

# Move the generated framework to the desired path
mv frameworks/openssl.xcframework "$FW_PATH"
