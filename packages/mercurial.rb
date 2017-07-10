require 'package'

class Mercurial < Package
  description 'Mercurial is a free, distributed source control management tool. It efficiently handles projects of any size and offers an easy and intuitive interface.'
  homepage 'https://www.mercurial-scm.org/'
  version '4.1'
  source_url 'https://www.mercurial-scm.org/release/mercurial-4.1.tar.gz'
  source_sha256 '7b33c32cdd1d518bc2e2ae223e6ef63c486cf52e9d01a45b99cf8eab7bea5274'

  # what's the best route for adding a minimum version symbol as a constraint?
  depends_on "python27"
  depends_on "zlibpkg"

  def self.build
    # would be great to avoid even downloading the source tarball if this dependency wasn't met
    py_ver = %x[python -V 2>&1 | awk '{ print $2 }'].strip
    abort '[!] python 2.7.13 or higher is required for tig, please run `crew upgrade python27` first.' unless py_ver > '2.7.12'
    if !%x[pip list | grep docutils].include? "docutils"
      puts "Installing docutils dependency..."
      system "pip", "install", "docutils"
    end
    system "make", "PREFIX=/usr/local", "all"
  end

  def self.install
    system "make", "DESTDIR=#{CREW_DEST_DIR}", "install"
    puts "------------------"
    puts "Installation success!"
    puts "Cleaning up dependencies only required for build..."
    system "pip", "uninstall", "docutils"
    puts
    puts "To begin using mercurial you'll need to configure it."
    puts
    puts "Run `hg debuginstall` and address any issues that it reports."
  end
end
