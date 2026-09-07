#!/bin/sh

echo "🚀 Setting up PulseFit development environment..."

check_brew_dep() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "✅ $1 is installed"
  else
    echo "📦 Installing $1 via Homebrew..."
    brew install "$1"
  fi
}

if command -v brew >/dev/null 2>&1; then
  check_brew_dep "swiftlint"
  check_brew_dep "swiftformat"
else
  echo "❌ Homebrew is not installed. Please install Homebrew first."
  exit 1
fi

if [ -d ".githooks" ]; then
  git config core.hooksPath .githooks
  echo "✅ Git hooks configured to '.githooks'"
fi

echo "🎉 Environment setup complete!"
