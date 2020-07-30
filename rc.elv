# DO NOT EDIT THIS FILE DIRECTLY
# This is a file generated from a literate programing source file located at
# https://gitlab.com/zzamboni/dot-elvish/-/blob/master/rc.org
# You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

E:GOPATH = ~/Dropbox/Personal/devel/go
paths = [
  ~/bin
  $E:GOPATH/bin
  /usr/local/opt/coreutils/libexec/gnubin
  /usr/local/opt/texinfo/bin
  /usr/local/opt/python/libexec/bin
  /usr/local/opt/ruby@2.6/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/sbin
  /sbin
  /usr/bin
  /bin
]

each [p]{
  if (not (-is-dir $p)) {
    echo (styled "Warning: directory "$p" in $paths no longer exists." red)
  }
} $paths

use epm

epm:install &silent-if-installed         ^
  github.com/zzamboni/elvish-modules     ^
  github.com/zzamboni/elvish-completions ^
  github.com/zzamboni/elvish-themes      ^
  github.com/xiaq/edit.elv               ^
  github.com/muesli/elvish-libs          ^
  github.com/iwoloschin/elvish-packages

use github.com/zzamboni/elvish-modules/proxy
proxy:host = "http://aproxy.corproot.net:8080"

proxy:test = {
  and ?(test -f /etc/resolv.conf) ^
  ?(egrep -q '^(search|domain).*(corproot.net|swissptt.ch)' /etc/resolv.conf)
}

proxy:autoset

use re

use readline-binding

edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

edit:insert:binding[Alt-d] = $edit:kill-small-word-right~

edit:insert:binding[Alt-m] = $edit:-instant:start~

edit:max-height = 20

use github.com/zzamboni/elvish-modules/alias

alias:new dfc e:dfc -p -/dev/disk1s4,devfs,map,com.apple.TimeMachine
alias:new cat bat
alias:new more bat --paging always
alias:new v vagrant

E:MANPAGER="sh -c 'col -bx | bat -l man -p'"

fn manpdf [@cmds]{
  each [c]{
    man -t $c | open -f -a /System/Applications/Preview.app
  } $cmds
}

use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply

use github.com/zzamboni/elvish-completions/vcsh
use github.com/zzamboni/elvish-completions/cd
use github.com/zzamboni/elvish-completions/ssh
use github.com/zzamboni/elvish-completions/builtins

use github.com/zzamboni/elvish-completions/git git-completions
git-completions:git-command = hub
git-completions:init

use github.com/zzamboni/elvish-completions/comp

use github.com/zzamboni/elvish-themes/chain
chain:bold-prompt = $false

chain:segment-style = [
  &dir=          session
  &chain=        session
  &arrow=        session
  &git-combined= session
  &git-repo=     bright-blue
]

chain:glyph[arrow]  = "|>"
chain:show-last-chain = $false

edit:prompt-stale-transform = [x]{ styled $x "bright-black" }

edit:-prompt-eagerness = 10

use github.com/zzamboni/elvish-modules/iterm2
iterm2:init
edit:insert:binding[Ctrl-L] = $iterm2:clear-screen~

use github.com/zzamboni/elvish-modules/long-running-notifications

use github.com/zzamboni/elvish-modules/bang-bang

use github.com/zzamboni/elvish-modules/dir
alias:new cd &use=[github.com/zzamboni/elvish-modules/dir] dir:cd
alias:new cdb &use=[github.com/zzamboni/elvish-modules/dir] dir:cdb

edit:insert:binding[Alt-i] = $dir:history-chooser~

edit:insert:binding[Alt-b] = $dir:left-small-word-or-prev-dir~
edit:insert:binding[Alt-f] = $dir:right-small-word-or-next-dir~

edit:insert:binding[Ctrl-R] = {
  edit:histlist:start
  edit:histlist:toggle-case-sensitivity
}

fn ls [@_args]{
  e:exa --color-scale --git --group-directories-first (each [o]{
      if (eq $o "-lrt") { put "-lsnew" } else { put $o }
  } $_args)
}

use github.com/zzamboni/elvish-modules/terminal-title

private-loaded = ?(use private)

use github.com/zzamboni/elvish-modules/atlas

use github.com/zzamboni/elvish-modules/opsgenie

use github.com/zzamboni/elvish-modules/leanpub

use github.com/zzamboni/elvish-modules/tinytex

E:LESS = "-i -R"

E:EDITOR = "vim"

E:LC_ALL = "en_US.UTF-8"

E:PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"

use github.com/zzamboni/elvish-modules/util

use github.com/muesli/elvish-libs/git

use github.com/iwoloschin/elvish-packages/update
update:curl-timeout = 3
update:check-commit &verbose

util:electric-delimiters

use github.com/zzamboni/elvish-modules/spinners
use github.com/zzamboni/elvish-modules/tty

use swisscom

-exports- = (alias:export)
