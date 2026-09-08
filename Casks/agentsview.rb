cask "agentsview" do
  version "0.42.0-local.292ef986"
  sha256 "782bec9a9da57947ca2cb2c699de3e76af9c884544d4391e8afa8e5a9afdf8f0"

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
