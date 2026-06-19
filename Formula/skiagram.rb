class Skiagram < Formula
  desc "CLI + TUI that profiles where your AI coding agent's tokens actually went — locally, offline."
  homepage "https://github.com/TanvirAnjumApurbo/skiagram"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.0/skiagram-aarch64-apple-darwin.tar.xz"
      sha256 "ff502d5a7fad9d03ad16fa1b32fd1f1f85f181944f3056f32219aa82cbce73d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.0/skiagram-x86_64-apple-darwin.tar.xz"
      sha256 "5f5ddcdfe50b0928ad415e6041e9b7b0f44935ea4d0f9eb284b8ed64a1f2ea1b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.0/skiagram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a2a36e2fbe17bb1fbcad1980aa84d3156f852eab01a5f1d57edb3ded7c8cc96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.0/skiagram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d15f5cc510d9a1f669f25d565cdddb9c852d0dbf61b2e61d39ff62a18eb84ff"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "skiagram" if OS.mac? && Hardware::CPU.arm?
    bin.install "skiagram" if OS.mac? && Hardware::CPU.intel?
    bin.install "skiagram" if OS.linux? && Hardware::CPU.arm?
    bin.install "skiagram" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
