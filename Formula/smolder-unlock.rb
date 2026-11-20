class SmolderUnlock < Formula
  desc "Bring a FileVault Mac back after a restart, from your phone (installer)"
  homepage "https://github.com/penntiao/smolder/tree/main/unlock"
  url "https://github.com/penntiao/smolder/archive/refs/tags/unlock-v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "4186ba471af0325400c8285d9b2891b68d87e43aaf540ff32523e58343ebe182"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "unlock/deploy.py", "unlock/config.example.json", "unlock/server"
    doc.install "unlock/README.md", "unlock/README.zh-CN.md", "unlock/AGENTS.md"
    (bin/"smolder-unlock").write <<~SH
      #!/bin/sh
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{libexec}/deploy.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Read where your password travels before you use this:
        #{doc}/README.md   (简体中文: README.zh-CN.md)
      AI agents: follow #{doc}/AGENTS.md

      Start in an empty folder:  smolder-unlock init
    EOS
  end

  test do
    assert_match "deploy.py plan", shell_output("#{bin}/smolder-unlock 2>&1", 1)
  end
end
