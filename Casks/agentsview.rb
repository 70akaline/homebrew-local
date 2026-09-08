cask "agentsview" do
  version "0.42.0-local.907ef13e"
  sha256 "a6b3af7a32f1aefbc32df4e88276818640929927971d9ca01b29ccb3d517a39c"

  url "file://#{HOMEBREW_PREFIX}/var/agentsview-local/agentsview-#{version}.zip"
  name "AgentsView"
  desc "Local viewer for AI agent sessions, built from local source"
  homepage "https://agentsview.io/"

  livecheck do
    skip "Locally built source snapshot"
  end

  depends_on arch: :arm64

  app "AgentsView.app"
  binary "#{appdir}/AgentsView.app/Contents/MacOS/agentsview"
end
