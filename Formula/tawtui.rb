# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.2.10"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v0.2.10/tawtui-darwin-arm64"
  sha256 "544601902ccb16c69a99041ed2da280c080de2ffceed7f71c1f15ee13aa96226"

  resource "notify-helper" do
    url "https://github.com/victorstein/tawtui/releases/download/v0.2.10/tawtui-notify-darwin-arm64.tar.gz"
    sha256 "bab01e4f0b8afc08d5993e22f9fbbab4ac0132bb0d8b46e100937dc64e2046d8"
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "tawtui-darwin-arm64" => "tawtui"

    resource("notify-helper").stage do
      (libexec / "TaWTUI Notify.app").install Dir["TaWTUI Notify.app/*"]
    end
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

      Notification helper installed to:
        #{libexec}/TaWTUI Notify.app

      If macOS blocks the notification helper, run:
        xattr -cr #{libexec}/TaWTUI Notify.app

      Run `tawtui` to launch the setup wizard.
    EOS
  end

  test do
    assert_match "tawtui", shell_output("#{bin}/tawtui --help 2>&1", 1)
  end
end
