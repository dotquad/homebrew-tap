class Dotquad < Formula
  desc "IP lookup, DNS, WHOIS and domain checks from the terminal, using the Dotquad API."
  homepage "https://dotquad.app"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/dotquad/cli/releases/download/v0.1.1/dotquad-aarch64-apple-darwin.tar.xz"
    sha256 "e399c9896d416d2aa05c767af8ba6ea0ad8d43e86bf4604021e1c9e9a53fb447"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dotquad/cli/releases/download/v0.1.1/dotquad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af7f221a3f1abdd2549fef4473077202fdac3f4cbc811570acc23c93ef5e36ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dotquad/cli/releases/download/v0.1.1/dotquad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13aa5947833863ed4785b7c743970ae95f8243d095b1dd37473ebedb4978b57c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dotquad"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dotquad"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dotquad"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
