class Skiagram < Formula
  desc "CLI + TUI that profiles where your AI coding agent's tokens actually went — locally, offline."
  homepage "https://github.com/TanvirAnjumApurbo/skiagram"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.1/skiagram-aarch64-apple-darwin.tar.xz"
      sha256 "b1dee738b5234e670ba337712eafc329457221bf8e01c95d58e9d03969c3ae43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.1/skiagram-x86_64-apple-darwin.tar.xz"
      sha256 "a4ed2208bcd078ba841def3a4281e05dc0b5fc73ee3d51a23a630f54dc6ac874"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.1/skiagram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "285a765b00d7bfc57b136cbe390ea762a335e9fc5cd5fa952d7d84a12de01b22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TanvirAnjumApurbo/skiagram/releases/download/v0.1.1/skiagram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43700047163b656a96a5831fcaa27774e7287c65c5515b34c38482bfc5ec9444"
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
