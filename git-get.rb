require "formula"

class GitGet < Formula
  VERSION = "0.5.0"

  version VERSION
  homepage "https://github.com/jwaldrip/git-get"
  head "https://github.com/jwaldrip/git-get.git", branch: "master"
  url "https://github.com/jwaldrip/git-get.git", using: :git, tag: "v#{VERSION}"

  depends_on "go" => :build

  ORIG_ENV = ENV.to_hash

  def install
    Dir.mktmpdir do |dir|
      ENV["GOBIN"] = bin
      ENV["GOPATH"] = dir
      ENV["GOHOME"] = dir
      srcpath, _ = mkdir_p File.join dir, '/src/github.com/jwaldrip'
      linkpath = File.join(srcpath, 'git-get')
      cp_r buildpath.to_s, linkpath
      cd linkpath do
        system("go env")
        system("make build")
        bin.install './bin/git-get' => "git-get"
      end
    end
  end

  def caveats
    if ORIG_ENV['GITPATH']
      <<-EOS.undent

        Your git path is set to `#{ORIG_ENV['GITPATH']}`. git-get will clone projects
        to #{ORIG_ENV['GITPATH']}.
      EOS
    elsif ORIG_ENV['GOPATH']
      <<-EOS.undent

        Your go path is set to `#{ORIG_ENV['GOPATH']}`. git-get will clone projects to
        `#{ORIG_ENV['GOPATH']}/src` unless you set GITPATH in your environment.

        EXAMPLE:
        $ echo "export GITPATH=$HOME/dev" > .bashprofile

      EOS
    else
      <<-EOS.undent

        Be sure to set your GITPATH or GOPATH before using git-get.

        EXAMPLE:
        $ echo "export GITPATH=$HOME/dev" > .bashprofile

      EOS
    end
  end

  test do
    path = testpath
    Kernel.system({ "GITPATH" => path.to_s }, "#{bin}/git-get", "https://github.com/jwaldrip/git-get.git", out: '/dev/null', err: '/dev/null')
    assert File.exist?("#{path}/github.com/jwaldrip/git-get/.git")
  end
end
