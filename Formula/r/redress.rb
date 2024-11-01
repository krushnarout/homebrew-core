class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "fb0ed565116c5f92a91dea7cdc47e394d6e5fb207e77147dce2e821742c0d9ee"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab2838cbe6c5331a2f56a5e794da25e69f3a51d88d7ac84e1aa98a2a38623c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab2838cbe6c5331a2f56a5e794da25e69f3a51d88d7ac84e1aa98a2a38623c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ab2838cbe6c5331a2f56a5e794da25e69f3a51d88d7ac84e1aa98a2a38623c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ee97fc76a01688fd195552ebdcaf6a41e4825e417382b6173b611cd3c1f24d"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ee97fc76a01688fd195552ebdcaf6a41e4825e417382b6173b611cd3c1f24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ed1f15f1a10f91480b70963176b449fcc6332d412aafdb036546dd299adc48"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
