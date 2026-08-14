# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.3.2"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v0.3.2/tawtui-darwin-arm64"
  sha256 "17215b6ff2024ed7fe833146e7fd4312d24a2bcdacf9db1c5a569505a102cb05"

  resource "notify-helper" do
    url "https://github.com/victorstein/tawtui/releases/download/v0.3.2/tawtui-notify-darwin-arm64.tar.gz"
    sha256 "d7669ae1cda30690fe662d4f83b4175eaf9329a4d21408bcfa0d8608d572bfa4"
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
