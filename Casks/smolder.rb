cask "smolder" do
  version "0.1.0"
  sha256 "893878978bb9caac6df878307109cd6f41a7d185b744d4e8cfce17bd3268ce7b"

  url "https://github.com/penntiao/smolder/releases/download/v#{version}/Smolder-#{version}.zip"
  name "Smolder"
  desc "Menu bar thermal watchdog for always-on, lid-closed Macs"
  homepage "https://github.com/penntiao/smolder"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Smolder.app"

  # Smolder is ad-hoc signed, not notarized. Clear the download quarantine so macOS lets it start;
  # build from source (see the README) if you prefer not to trust the binary.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Smolder.app"]
  end

  uninstall launchctl: "io.github.penntiao.smolder",
            quit:      "io.github.penntiao.smolder"

  zap trash: [
    "~/Library/Application Support/Smolder",
    "~/Library/LaunchAgents/io.github.penntiao.smolder.plist",
  ]

  caveats <<~EOS
    Smolder is not notarized; this cask removes the quarantine flag after installing.
    Open Smolder, then turn on Settings → General → "Start at login and restart after a crash".
  EOS
end
