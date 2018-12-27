require "net/http"
require "formula"

class Fastpass < Formula
  LATEST_RELEASE = JSON.parse(Net::HTTP.get(URI("https://api.github.com/repos/jwaldrip/fastpass/releases/latest")))
  TAG = LATEST_RELEASE["tag_name"]
  pp LATEST_RELEASE
  URL = LATEST_RELEASE["assets"].find { |asset| asset["name"].include? "osx" }["browser_download_url"]

  version TAG.sub(/^v/, '')
  homepage 'https://github.com/jwaldrip/fastpass'
  head 'https://github.com/jwaldrip/fastpass.git', branch: 'master'
  url URL

  depends_on 'openssl'
  depends_on 'libyaml'
  depends_on 'bdw-gc'
  depends_on "libevent"
  depends_on "pcre"
  depends_on "gmp"

  def install
    bin.install "fastpass"
  end
end
