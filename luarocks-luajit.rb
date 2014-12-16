require "formula"

class LuarocksLuajit < Formula
  homepage "http://luarocks.org"
  url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
  sha1 "e2de00f070d66880f3766173019c53a23229193d"
  revision 1

  bottle do
    sha1 "eabd3d0f2bb7979ac831ce948e8d288569d2a0c8" => :mavericks
    sha1 "fb6956c0ee42f3bfdde280693cf28d32b3587e55" => :mountain_lion
    sha1 "140ee3fd55954d1fd30984620d8f109056ef56f9" => :lion
  end

  head "https://github.com/keplerproject/luarocks.git"

  option "with-luajit", "Use LuaJIT instead of the stock Lua"
  option "with-lua51", "Use Lua 5.1 instead of the stock Lua"

  if build.with? "luajit"
    depends_on "luajit"
    # luajit depends internally on lua being installed
    # and is only 5.1 compatible, see #25954
    depends_on "lua51"
  elsif
   build.with? "lua51"
    depends_on "lua51"
  else
    depends_on "lua"
  end

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks"]

    if build.with? "lua"
      lua_prefix = Formula["lua"].opt_prefix

      args << "--with-lua=#{lua_prefix}"
      args << "--lua-version=5.2"
    end

    if build.with? "lua51"
      lua51_prefix = Formula["lua51"].opt_prefix

      args << "--with-lua=#{lua51_prefix}"
      args << "--with-lua-include=#{lua51_prefix}/include/lua-5.1"
      args << "--lua-version=5.1"
      args << "--lua-suffix=5.1"
    end

    if build.with? "luajit"
      luajit_prefix = Formula["luajit"].opt_prefix

      args << "--with-lua=#{luajit_prefix}"
      args << "--lua-version=5.1"
      args << "--lua-suffix=jit"
      args << "--with-lua-include=#{luajit_prefix}/include/luajit-2.0"
    end

    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Rocks install to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    You may need to run `luarocks install` inside the Homebrew build
    environment for rocks to successfully build. To do this, first run `brew sh`.
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end