class ClaudeUsageStatusline < Formula
  desc "Claude Code status line showing Pro subscription usage"
  homepage "https://github.com/victorstein/claude-code-usage-statusline"
  license "MIT"

  url "https://github.com/victorstein/claude-code-usage-statusline/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "b3b6db8494655f80f63c2f71e771e745e56bf8de1b1f5ac62717ded662046eb4"

  depends_on :macos
  depends_on "python@3"

  def install
    bin.install "claude-usage-statusline.py" => "claude-usage-statusline"
  end

  def post_install
    require "json"

    settings_path = Pathname.new(Dir.home) / ".claude" / "settings.json"
    settings_path.parent.mkpath

    settings = if settings_path.exist?
      JSON.parse(settings_path.read) rescue {}
    else
      {}
    end

    settings["statusLine"] = {
      "type"    => "command",
      "command" => "claude-usage-statusline",
    }

    content = JSON.pretty_generate(settings) + "\n"
    File.open(settings_path.to_s, "w") { |f| f.write(content) }
  rescue Errno::EPERM, Errno::EACCES
    opoo "Could not auto-configure Claude Code settings (permission denied)."
    opoo "Run from a regular terminal (not inside Claude Code):"
    opoo "  brew postinstall victorstein/tap/claude-usage-statusline"
  end

  def caveats
    <<~EOS
      Claude Code has been configured automatically (#{Dir.home}/.claude/settings.json).
      If the status line is missing, run from a regular terminal:
        brew postinstall victorstein/tap/claude-usage-statusline

      Make sure you are logged into claude.ai in Google Chrome before starting
      a Claude Code session — cookies are extracted automatically on first run.

      To clear the usage cache:
        rm -rf ~/.cache/claude-usage/
    EOS
  end

  test do
    output = pipe_output(
      "#{bin}/claude-usage-statusline",
      '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":42}}'
    )
    assert_match "Opus", output
    assert_match "42%", output
  end
end
