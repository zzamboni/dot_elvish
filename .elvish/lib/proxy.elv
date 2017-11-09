# Proxy manipulation
# Diego Zamboni <diego@zzamboni.org>
# To use it, add the following to your rc.elv:
#
#   use proxy
#   proxy:host = "proxy.corpnet.com:8079"
#
# You can then manually enable/disable the proxy by calling proxy:set and proxy:unset
#
# If you want to enable automatic proxy switching, you need to define
# a check function and add the corresponding hook. For example:
# 
#   proxy:test = { and ?(test -f /etc/resolv.conf) ?(egrep -q '^(search|domain).*corpnet.com' /etc/resolv.conf) }
#   prompt_hooks:add-before-readline { proxy:autoset }

# Proxy host to used. Usual format: host:port
host = ""

# This function should return a true value when the proxy needs to be set, false otherwise
# By default it returns false, you should override it with code that performs a meaningful
# check for your needs.
test = { put $false }

# Whether to print notifications when setting/unsetting the proxy
notify = $true

# Internal variable to avoid notifying more than once.
has_been_set = $false

# Whether autoset should be disabled (useful for temporarily stopping the automatic proxy setting)
disable_autoset = $false

# Set the proxy variables to the given string
fn set [host]{
  E:http_proxy = $host
  E:https_proxy = $host
  has_been_set = $true
}

# Unset the proxy variables
fn unset {
  del E:http_proxy
  del E:https_proxy
  has_been_set = $false
}

# Disable auto-set and unset the proxy
fn disable {
  disable_autoset = $true
  unset
}

# Enable auto-set
fn enable {
  disable_autoset = $false
}

# Automatically set the proxy by running `proxy:test` and setting/unsetting depending
# on the result
fn autoset {
  if (not $disable_autoset) {
    if ($test) {
      if (and $host (not (eq $host ""))) {
        if (and $notify (not $has_been_set)) { echo (edit:styled "Setting proxy "$host blue) }
        set $host
      } else {
        fail "You need to set $proxy:host to the proxy to use"
      }
    } else {
      if (and $notify $has_been_set) { echo (edit:styled "Unsetting proxy" blue) }
      unset
    }
  }
}
