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
    alias cn='claude -w'       # new claude session with worktree
    alias cr='claude --resume'  # resume existing claude session
    alias x='codex'
    alias xn='cw'               # new codex session with worktree
    alias xr='codex resume'     # resume existing codex session
    alias xrl='codex resume --last'

    function cw --description 'Create a git worktree and start Codex in it'
        set -l branch
        if test (count $argv) -gt 0
            set branch $argv[1]
            set -e argv[1]
        else
            set branch codex/(date "+%Y%m%d-%H%M%S")
        end

        set -l root (git rev-parse --show-toplevel 2>/dev/null)
        if test $status -ne 0
            echo "cw: not in a git repository"
            return 1
        end

        set -l repo_name (basename "$root")
        set -l parent (dirname "$root")
        set -l worktree_name (string replace -ra '[^A-Za-z0-9._-]+' '-' "$branch")
        set -l worktree "$parent/$repo_name-$worktree_name"

        if test -e "$worktree"
            echo "cw: $worktree already exists"
            return 1
        end

        if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"
            git -C "$root" worktree add "$worktree" "$branch"
        else
            git -C "$root" worktree add -b "$branch" "$worktree"
        end

        if test $status -ne 0
            return $status
        end

        codex --cd "$worktree" $argv
    end
end

starship init fish | source
