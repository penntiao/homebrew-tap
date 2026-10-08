cask "smolder" do
  version "0.1.6"
  sha256 "cf66ba1850079b8f2ebd292f2557c56c7754796f59f4dccc859ba197a9d64bb0"

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

  # No `launchctl:` here: Homebrew runs uninstall directives on every upgrade, which would delete the
  # user's LaunchAgent. After an upgrade Homebrew reopens the app and it hands itself back to launchd.
  uninstall quit: "io.github.penntiao.smolder"

  zap trash: [
    "~/Library/Application Support/Smolder",
    "~/Library/LaunchAgents/io.github.penntiao.smolder.plist",
  ]

  caveats <<~EOS
    Smolder is not notarized; this cask removes the quarantine flag after installing.
    Open Smolder, then turn on Settings → General → "Start at login and restart after a crash".
    To remove that LaunchAgent and all data as well, uninstall with `brew uninstall --zap smolder`.
  EOS
end
