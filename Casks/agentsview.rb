cask "agentsview" do
  version "0.42.0-local.907ef13e"
  sha256 "8c667fc61bf780aa9b8097d9121a8c370eb82dae4da85b908d631f529ded3397"

  url "https://github.com/70akaline/agentsview/releases/download/fork-#{version}/agentsview-#{version}.zip"
  name "AgentsView"
  desc "Viewer for AI agent sessions with fork-specific improvements"
  homepage "https://github.com/70akaline/agentsview"

  livecheck do
    skip "Pinned fork snapshot"
  end

  depends_on arch: :arm64

  app "AgentsView.app"
  binary "#{appdir}/AgentsView.app/Contents/MacOS/agentsview"
end
