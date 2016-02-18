class Arpwatch < Formula
  desc "arpwatch is a computer software tool for monitoring Address Resolution Protocol traffic on a computer network."
  url "ftp://ftp.ee.lbl.gov/arpwatch-2.1a15.tar.gz"
  homepage "http://ee.lbl.gov/"
  sha256 "c1df9737e208a96a61fa92ddad83f4b4d9be66f8992f3c917e9edf4b05ff5898"

  # needs libpcap

  def install

    # patch makefile to avoid permission errors
    chmod 0644, %w[Makefile.in]
    inreplace "Makefile.in",
      '$(INSTALL) -m 555 -o bin -g bin arpwatch $(DESTDIR)$(BINDEST)',
      "mkdir -p $(DESTDIR)$(BINDEST)\n\t$(INSTALL) -m 555 arpwatch $(DESTDIR)$(BINDEST)"
    inreplace "Makefile.in",
      '$(INSTALL) -m 555 -o bin -g bin arpsnmp $(DESTDIR)$(BINDEST)',
      '$(INSTALL) -m 555 arpsnmp $(DESTDIR)$(BINDEST)'
    inreplace "Makefile.in",
      '$(INSTALL) -m 444 -o bin -g bin $(srcdir)/arpwatch.8 \\',
      "mkdir -p $(DESTDIR)$(MANDEST)\n\t$(INSTALL) -m 444 $(srcdir)/arpwatch.8 \\"
    inreplace "Makefile.in",
      '$(INSTALL) -m 444 -o bin -g bin $(srcdir)/arpsnmp.8 \\',
      '$(INSTALL) -m 444 $(srcdir)/arpsnmp.8 \\'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def post_install
    (prefix/"arpwatch").mkdir
    touch prefix/"arpwatch/arp.dat"
  end
end
