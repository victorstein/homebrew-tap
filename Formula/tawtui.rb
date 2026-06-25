# typed: false
# frozen_string_literal: true

class Tawtui < Formula
  desc "Terminal UI for Taskwarrior, GitHub PRs, and Google Calendar"
  homepage "https://github.com/victorstein/tawtui"
  version "0.3.0"
  license "MIT"

  url "https://github.com/victorstein/tawtui/releases/download/v0.3.0/tawtui-darwin-arm64"
  sha256 "be915fb416764ec50f0a08c933021bcad9e54a7b12220a40b020e8c554715b1a"

  resource "notify-helper" do
    url "https://github.com/victorstein/tawtui/releases/download/v0.3.0/tawtui-notify-darwin-arm64.tar.gz"
    sha256 "86b25e3dca5a355972a0dbf75a0d175bdda59bb169982f40c38826d7c4a2b5b5"
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
