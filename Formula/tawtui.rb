# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.2.3"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v#{version}/tawtui-darwin-arm64"
  sha256 "afcd25eca8ec15bad8374670160983730419a00fb2e227c84180f43a48cbb0f0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "tawtui-darwin-arm64" => "tawtui"
  end

  def caveats
    <<~EOS
      tawtui requires the following tools:

      Required:
        - Taskwarrior (task): brew install task
        - GitHub CLI (gh):    brew install gh
        - tmux:               brew install tmux

      Optional:
        - Google Calendar:    brew install steipete/tap/gogcli

      Run `tawtui` to launch the setup wizard.
    EOS
  end

  test do
    assert_match "tawtui", shell_output("#{bin}/tawtui --help 2>&1", 1)
  end
end
