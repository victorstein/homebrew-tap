class ClaudeUsageStatusline < Formula
  desc "Claude Code status line showing Pro subscription usage"
  homepage "https://github.com/victorstein/claude-code-usage-statusline"
  license "MIT"

  url "https://github.com/victorstein/claude-code-usage-statusline/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "ec31795d187b39f4ecebba4127792144cb2c23122ac60f70b011659921afeb1e"

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

    settings_path.write(JSON.pretty_generate(settings) + "\n")
  end

  def caveats
    <<~EOS
      Claude Code has been configured automatically (#{Dir.home}/.claude/settings.json).

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
