class Lumentui < Formula
  desc "Elegant NestJS-based product monitoring system with real-time macOS notifications"
  homepage "https://github.com/victorstein/lumentui"
  url "https://registry.npmjs.org/lumentui/-/lumentui-1.3.1.tgz"
  sha256 "b1346cd0f00816601c3b73bdca107479675b8721d191bf424232f718d2862288"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"lumentui", "--help"
  end
end
