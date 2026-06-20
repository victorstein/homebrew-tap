# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.2.12"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v0.2.12/tawtui-darwin-arm64"
  sha256 "4d40748047ba00b501bb844d388602d94b7f8a7c8c8f393820ac80b5694ecb0f"

  resource "notify-helper" do
    url "https://github.com/victorstein/tawtui/releases/download/v0.2.12/tawtui-notify-darwin-arm64.tar.gz"
    sha256 "77023cff067f7ac0a699717642824d32060a025ac0c1e87d4848edc8397124d6"
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
