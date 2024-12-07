class AzurePimCli < Formula
  desc "Unofficial CLI for Azure Privileged Identity Management (PIM) roles"
  homepage "https://github.com/demoray/azure-pim-cli"
  url "https://github.com/demoray/azure-pim-cli/archive/refs/tags/0.8.0.tar.gz"
  sha256 "7505843a58bf5bd44882a1a4ad646f8afd11327e4709180f11daed0b758ed36b"
  license "MIT"
  head "https://github.com/demoray/azure-pim-cli.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "azure-cli"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/az-pim --version")
  end
end
