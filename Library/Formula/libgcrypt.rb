require 'formula'

class Libgcrypt < Formula
  homepage 'http://gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.1.tar.bz2'
  sha1 '8b60a26b7eae1a727d58932d6b1efeb5716648ed'

  depends_on 'libgpg-error'

  option :universal

  def patches
    if ENV.compiler == :clang
      {:p0 =>
      "https://trac.macports.org/export/85232/trunk/dports/devel/libgcrypt/files/clang-asm.patch"}
    end
  end

  def cflags
    cflags = ENV.cflags.to_s
    cflags += ' -std=gnu89 -fheinous-gnu-extensions' if ENV.compiler == :clang
    cflags
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"
    # Parallel builds work, but only when run as separate steps
    system "make", "CFLAGS=#{cflags}"
    system "make check"
    system "make install"
  end
end
