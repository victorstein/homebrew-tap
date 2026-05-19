# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.2.11"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v0.2.11/tawtui-darwin-arm64"
  sha256 "fc2598cdce6be3b30490f696d15b8f8da7f5cec64250216a30b19ca34c418ac1"

  resource "notify-helper" do
    url "https://github.com/victorstein/tawtui/releases/download/v0.2.11/tawtui-notify-darwin-arm64.tar.gz"
    sha256 "72c3f74dbfbf732afe831734777a822036709aa8da9c68aea83a009730e9e3cf"
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
