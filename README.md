# Homebrew-luarocks
===
These formulae provide luarocks-3.0.0

This tap is for LuaJIT stuffs in homebrew. For now, it's just the custom install of luarocks which works with LuaJIT (as opposed to defaulting to lua 5.2). It is taken from @DomT4's [gist](https://gist.github.com/DomT4/bc1e58d8237806b23464). Thank you Dominyk.

The luarocks-luajit formula also takes a `--with-lua51` parameter, which optionally lets you install luarocks with Lua 5.1. I'm not sure if parallel LuaJIT and Lua 5.1 install will work, I haven't tested this. Just use LuaJIT ;-)

At some stage I would like to put the formula for installing LuaJIT 2.1 beta-3 here as well. Pull requests welcome.

## Installing

brew install https://raw.githubusercontent.com/dai-yamashita/homebrew-luajit/master/luarocks-luajit.rb [--with-luajit]