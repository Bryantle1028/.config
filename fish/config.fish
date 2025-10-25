source ~/.fish_aliases

set fish_cursor_visual underscore
set fish_cursor_default underscore
set fish_cursor_insert underscore

set -Ux LSCOLORS exfxcxdxbxegedabagacad

# Load API keys from private config file (not tracked in git)
if test -f ~/.config/fish/private.fish
    source ~/.config/fish/private.fish
end

function ls --description 'List contents of directory'
    set -lx LS_COLORS 'di=36:fi='
    command ls --color=auto -F $argv
end

fish_add_path /opt/homebrew/bin

# vi command line mode
fish_vi_key_bindings

# override control f
bind -M insert \cf accept-autosuggestion
bind -M visual \cf accept-autosuggestion
bind -M default \cf accept-autosuggestion

# Tell starship about vi mode changes
function fish_mode_prompt
    # Don't print anything - just let starship handle the display
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
