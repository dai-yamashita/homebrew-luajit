require "formula"

class LuarocksLuajit < Formula
  homepage "https://luarocks.org"
  url "http://luarocks.org/releases/luarocks-3.3.1.tar.gz"
  sha256 "eb20cd9814df05535d9aae98da532217c590fc07d48d90ca237e2a7cdcf284fe"
  revision 1

  # bottle do
  # sha256 "4848129fc7affc5949c240f571c5e8d0684bbd142f8dc2e18176b3a8f165b2bb" => :high_sierra
  # sha256 "bdebedd2ab2bea98e10591308a5246c81aa7628ee7d17a0f20aeebeebf8bec22" => :sierra
  # sha256 "1d7aaa71d670da1e52b92e6db270ba935b9047e08e5cda52c70b14623d1b5bdf" => :el_capitan
  # sha256 "a96de1c4d07aac2ee35f8df2498e305da7466fed04ae291d42bd63c24e8dc658" => :yosemite
  # sha256 "eabd3d0f2bb7979ac831ce948e8d288569d2a0c8" => :mavericks
  # sha256 "fb6956c0ee42f3bfdde280693cf28d32b3587e55" => :mountain_lion
  # sha256 "140ee3fd55954d1fd30984620d8f109056ef56f9" => :lion
  # end

  head "https://github.com/keplerproject/luarocks.git"

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    luajit_prefix = Formula["luajit"].opt_prefix

    args << "--with-lua=#{luajit_prefix}"
    args << "--lua-version=5.1"
    args << "--lua-suffix=jit"
    args << "--with-lua-include=#{luajit_prefix}/include/luajit-2.1"
    
    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats
    print "Luarocks is available at: #{HOMEBREW_PREFIX}/bin/luarocks-jit\n"
    print "Rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks-5.1\n"
    print "A configuration file has been placed at: #{HOMEBREW_PREFIX}/etc/luarocks/config-5.1.lua\n"
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end
