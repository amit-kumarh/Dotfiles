wikipedia() {
    lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki/$@"
}

duckduckgo() {
    lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q='$@'"
}
