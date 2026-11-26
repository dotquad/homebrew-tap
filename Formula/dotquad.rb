class Dotquad < Formula
  desc "IP lookup, DNS, WHOIS and domain checks from the terminal, using the Dotquad API."
  homepage "https://dotquad.app"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dotquad/cli/releases/download/v0.1.0/dotquad-aarch64-apple-darwin.tar.xz"
      sha256 "946003b1df77a0a455bc0e73bce7aa50b5b19a0700fb41f7faebeacde1cfa014"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dotquad/cli/releases/download/v0.1.0/dotquad-x86_64-apple-darwin.tar.xz"
      sha256 "82873aa2d5a067fcc05cbd0afccbcc232f851c0a7895aa1f4d4cf89a3d6cb6ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dotquad/cli/releases/download/v0.1.0/dotquad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "435db146d51ba2a537e87934506367df5328f410009bb3881014a4962611799e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dotquad/cli/releases/download/v0.1.0/dotquad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c9dca62843ee622bb584edc874cbc4de0129b41cedb109748aa4016644d840e6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.intel?
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
