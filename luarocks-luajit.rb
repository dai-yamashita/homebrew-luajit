require "formula"

class LuarocksLuajit < Formula
  homepage "https://luarocks.org"
  url "https://luarocks.org/releases/luarocks-3.0.4.tar.gz"
  sha256 "ce82a2ebe8b5707d18aa99b56cbb995147fee55749f0d994157e8ed62d29f2d4"
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

  option "with-lua51",  "Use Lua 5.1 instead of LuaJIT"

  if build.with? "lua51"
    depends_on "lua51"
  else
    depends_on "luajit --with-gc64"
    # luajit depends internally on lua being installed
    # and is only 5.1 compatible, see #25954
    # depends_on "lua51"
  end

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    if build.with? "lua51"
      lua51_prefix = Formula["lua51"].opt_prefix

      args << "--with-lua=#{lua51_prefix}"
      args << "--with-lua-include=#{lua51_prefix}/include/lua-5.1"
      args << "--lua-version=5.1"
      args << "--lua-suffix=5.1"

    else
      luajit_prefix = Formula["luajit"].opt_prefix

      args << "--with-lua=#{luajit_prefix}"
      args << "--lua-version=5.1"
      args << "--lua-suffix=jit"
      args << "--with-lua-include=#{luajit_prefix}/include/luajit-2.1"
    end

    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats
    if build.with? "lua51"
      print "Luarocks is available at: #{HOMEBREW_PREFIX}/bin/luarocks-5.1\n"
    else
      print "Luarocks is available at: #{HOMEBREW_PREFIX}/bin/luarocks-jit\n"
    end
    print "Rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks-5.1\n"
    print "A configuration file has been placed at: #{HOMEBREW_PREFIX}/etc/luarocks/config-5.1.lua\n"
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end
